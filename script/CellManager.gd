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
	return self.cells[idx]


func set_cell(cell_position: Vector2i, cell: TetroBlock) -> void:
	var idx = self.get_cell_idx(cell_position)
	self.cells[idx] = cell


## Get cell position in (x, y) of given pixel position of a single cell
## Sicne we only store TetroBlock in our cells, and TetroBlock is a square with centered sprites,
## we can get its cells position if it moves by block size.
## [code]pixel_position[/code] is the relative position from a block to the playing area, not the tetromino.
static func get_cell_position(pixel_position: Vector2) -> Vector2i:
	var x: int = floori(pixel_position.x / TetroBlock.BLOCK_SIZE)
	var y: int = floori(pixel_position.y / TetroBlock.BLOCK_SIZE)
	return Vector2i(x, y)


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
	# This is actually block_position relative to tetromino's parent node
	var block_position_relative = block_parent_tetro.position + block.position
	return CellManager.get_cell_position(block_position_relative)


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


## Place each tetro block into their cell position, this method does not care whether it's already in the cell or not
func set_tetro_cells(tetro: Tetromino):
	for block in tetro.get_children():
		var cell_position = CellManager.get_cell_position_of_block(block, tetro)
		self.set_cell(cell_position, block)


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
