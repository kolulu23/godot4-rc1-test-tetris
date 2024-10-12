extends Node2D
class_name CellManager

## One dimension array for our [code]cell_width * cell_height[/code] cells
var cells: Array[TetroBlock]
var cell_width: int
var cell_height: int


func get_cell_idx(cell_position: Vector2i) -> int:
	return cell_position.y * cell_width + cell_position.x


func get_cell(cell_position: Vector2i) -> TetroBlock:
	var idx = self.get_cell_idx(cell_position)
	var cell = self.cells[idx]
	if cell != null and cell.is_inside_tree() and !cell.is_queued_for_deletion():
		return cell
	else:
		return null


## Get all cells at row [code]y[/code], from 0 to [member cell_width]
func get_cell_at_row(y: int) -> Array[TetroBlock]:
	var cells_at_row: Array[TetroBlock] = []
	for x in range(self.cell_width):
		var cell = self.get_cell(Vector2(x, y))
		cells_at_row.push_back(cell)
	return cells_at_row


func set_cell(cell_position: Vector2i, cell: TetroBlock) -> void:
	var idx = self.get_cell_idx(cell_position)
	self.cells[idx] = cell


static func get_pixel_position(cell_position: Vector2i) -> Vector2:
	# TetroBlock.BLOCK_SIZE_HALF is our offset to both (x, 0) and (0, y)
	var x: float = cell_position.x * TetroBlock.BLOCK_SIZE + TetroBlock.BLOCK_SIZE_HALF
	var y: float = cell_position.y * TetroBlock.BLOCK_SIZE + TetroBlock.BLOCK_SIZE_HALF
	return Vector2(x, y)


## Get cell position in (x, y) of given pixel position of a single cell
## Sicne we only store TetroBlock in our cells, and TetroBlock is a square with centered sprites,
## we can get its cells position if it moves by block size.
## [code]pixel_position[/code] is the relative position from a block to the playing area, not the tetromino.
static func get_cell_position(pixel_position: Vector2) -> Vector2i:
	var x: int = floori(pixel_position.x / TetroBlock.BLOCK_SIZE)
	var y: int = floori(pixel_position.y / TetroBlock.BLOCK_SIZE)
	return Vector2i(x, y)


## Get cell positions in (x, y) for each items in [code]pixel_positions[/code]. See [member get_cell_position]
static func get_cell_positions(pixel_positions: Array[Vector2]) -> Array[Vector2i]:
	var cell_positions: Array[Vector2i] = []
	for pixel_position in pixel_positions:
		var cell_position = CellManager.get_cell_position(pixel_position)
		cell_positions.push_back(cell_position)
	return cell_positions

## Get all the cell positions of tetromino blocks from one single tetromino.
## The returned positions are ordered just as the tetromino child block nodes.
static func get_cell_positions_of_tetro(tetro: Tetromino) -> Array[Vector2i]:
	var cell_positions: Array[Vector2i] = []
	for block in tetro.get_children():
		var cell_position = CellManager.get_cell_position_of_block(block, tetro)
		cell_positions.push_back(cell_position)
	return cell_positions


## Get cell position in (x, y) of given tetromino block.
## Since blocks are tetromino's children nodes, we can't calculate cell position without knowing where is the tetromino the block is in.
## Callers must present the related tetromino to get correct cell position.
static func get_cell_position_of_block(block: TetroBlock, block_parent_tetro: Tetromino) -> Vector2i:
	# This is actually block_position relative to tetromino's parent node: arena has to be at (0, 0)
	var block_position_relative = block_parent_tetro.to_global(block.position)
	return CellManager.get_cell_position(block_position_relative)

## Move a cell towards [code]direction[/code] regardless of what tetromino is belongs to.
func move_cell(cell: TetroBlock, direction: Vector2i):
	if cell == null:
		return
	var cell_pos = CellManager.get_cell_position_of_block(cell, cell.get_parent())
	var dest_pos = cell_pos + direction
	self.set_cell(cell_pos, null)
	self.set_cell(dest_pos, cell)
	cell.move_to(direction)


## Move a tetromino according to a destination. It will first clear related blocks, then reset those blocks to new cell.
## [code]src_array[/code]: Array of cell positions before moving the tetromino, it is passed separately so callers can choose when to update [code]tetro.position[/code]
## [code]dest_array[/code]: Array of cell positions after moving the tetromino
func move_tetro_cells(
	tetro: Tetromino, src_array: Array[Vector2i], dest_array: Array[Vector2i]
) -> void:
	var blocks = tetro.get_children()
	for cell_position in src_array:
		self.set_cell(cell_position, null)
	for i in range(dest_array.size()):
		self.set_cell(dest_array[i], blocks[i])


## This method updates tetro's cell position and its sprite position
func move_tetro_cells_to(tetro: Tetromino, direction: Vector2i) -> bool:
	var src_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	var dest_cell_positions: Array[Vector2i] = []
	for cell_positon in src_cell_positions:
		dest_cell_positions.push_back(cell_positon + direction)

	if !self.is_tetro_movable(tetro, dest_cell_positions):
		return false

	self.move_tetro_cells(tetro, src_cell_positions, dest_cell_positions)
	tetro.move_to(direction)
	return true


func rotate_tetro_cells_to(tetro: Tetromino, _rotation: float) -> bool:
	var dest_tetro = tetro.duplicate()
	dest_tetro.rotate(_rotation)
	var dest_cell_positions = CellManager.get_cell_positions_of_tetro(dest_tetro)

	if !self.is_tetro_movable(tetro, dest_cell_positions):
		return false

	var src_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	self.move_tetro_cells(tetro, src_cell_positions, dest_cell_positions)
	tetro.rotate(_rotation)
	dest_tetro.queue_free()
	return true


## Place each tetro block into their cell position, this method does not care whether it's already in the cell or not
func set_tetro_cells(tetro: Tetromino):
	for block in tetro.get_children():
		var cell_position = CellManager.get_cell_position_of_block(block, tetro)
		self.set_cell(cell_position, block)


## Checks if cell_position is still inside cells, to make a cell inbound, it must can be indexed by positive numbers and do not exceed cell size
func is_cell_inbound(cell_position: Vector2i) -> bool:
	if cell_position.x < 0 or cell_position.y < 0:
		return false
	if cell_position.x >= self.cell_width or cell_position.y >= self.cell_height:
		return false
	return true


## Checks if cell_position is occupied by a block.
## If [code]tetro[/code] is not null, then it will treat its child block as unoccupied cell.
func is_cell_occupied(cell_position: Vector2i, tetro: Tetromino = null) -> bool:
	var block = self.get_cell(cell_position)
	if block == null:
		return false
	if tetro == null:
		return true
	return not tetro.is_ancestor_of(block)


func is_tetro_movable(tetro: Tetromino, dest_cell_positions: Array[Vector2i]) -> bool:
	if dest_cell_positions.any(func(p): return not self.is_cell_inbound(p)):
		return false
	if dest_cell_positions.any(func(p): return self.is_cell_occupied(p, tetro)):
		return false
	return true


func _debug_print() -> void:
	for y in range(0, self.cell_height):
		var line = ""
		for x in range(0, self.cell_width):
			var idx = self.get_cell_idx(Vector2i(x, y))
			var cell_symbol = "."
			if self.cells[idx] != null:
				cell_symbol = "@"
			line += cell_symbol
		print(line)


## When one row of cells count to [member cell_width], it should be cleared and counts score
## This methods tries to clear as many cells as it can and returns the number of rows it cleared.
## Returns the number of cleared lines.
func line_clear() -> int:
	var lines_cleared: int = 0
	var lines_freed: Array[int] = []
	# Clear starts from bottom to top
	for y in range(self.cell_height - 1, 0, -1):
		var cell_line = self.get_cell_at_row(y)
		# Any empty cell in a line is considered not clearable
		if cell_line.any(func(block): return block == null):
			continue
		for cell in cell_line:
			cell.queue_free()
		lines_cleared += 1
		lines_freed.append(y)
	for y in lines_freed:
		# Move the one line above down if cell_line is cleared
		var cells_above = self.get_cell_at_row(y - 1)
		for cell in cells_above:
			self.move_cell(cell, Vector2i.DOWN)
	return lines_cleared
