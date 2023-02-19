extends Node2D
class_name Tetromino

enum TetroType { I, J, L, O, S, T, Z }

var tetro_type: TetroType


## Move to [code]direction[/code] relative to this node's parent
func move_to(direction: Vector2):
	self.position += TetroBlock.BLOCK_SIZE * direction


## Rotate self clockwise
func rotate_cw():
	self.rotation += PI / 2


## Rotate self counter-clockwise
func rotate_ccw():
	self.rotation -= PI / 2


func get_block_pixel_positions() -> Array[Vector2]:
	var block_positions: Array[Vector2] = []
	for block in self.get_children():
		block_positions.push_back(self.position + block.position)
	return block_positions


func _debug_print():
	for block in self.get_children():
		## This is actually block_position_relative_to_arena
		# var block_position = self.position + block.position
		var block_position = self.to_global(block.position)
		var cell_position = CellManager.get_cell_position(block_position)
		print(block.name, block_position, cell_position)
	print()
