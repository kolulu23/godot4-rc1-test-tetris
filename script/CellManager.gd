extends Node2D
class_name CellManager

## One dimension array for our [code]cell_width * cell_height[/code] cells
var cells: Array[TetroBlock]
var cell_width: int
var cell_height: int


func get_cell_idx(x: int, y: int) -> int:
	return y * cell_width + x


func get_cell(x: int, y: int) -> TetroBlock:
	var idx = self.get_cell_idx(x, y)
	return self.cells[idx]


func set_cell(x: int, y: int, cell: TetroBlock) -> void:
	var idx = self.get_cell_idx(x, y)
	self.cells[idx] = cell


## Get cell position in (x, y) of given pixel position of a single cell
## Sicne we only store TetroBlock in our cells, and TetroBlock is a square with centered sprites,
## we can get its cells position if it moves by block size.
## [code]pixel_position[/code] is the relative position from a block to the playing area, not the tetromino.
func get_cell_position(pixel_position: Vector2) -> Vector2i:
	var x: int = floori(pixel_position.x / TetroBlock.BLOCK_SIZE)
	var y: int = floori(pixel_position.y / TetroBlock.BLOCK_SIZE)
	return Vector2i(x, y)


func clear_cell() -> void:
	for i in range(0, self.cells.size()):
		var block = self.cells.pop_back()
		if block is null:
			continue
		block.queue_free()
