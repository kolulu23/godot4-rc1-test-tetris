extends Node2D
class_name Tetromino

enum TetroType { I, J, L, O, S, T, Z }

var tetro_type: TetroType


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func move_left():
	self.move_to(Vector2.LEFT)


func move_right():
	self.move_to(Vector2.RIGHT)


func move_down():
	self.move_to(Vector2.DOWN)


## Move to [code]direction[/code] relative to this node's parent
func move_to(direction: Vector2):
	self.position += TetroBlock.BLOCK_SIZE * direction


## Rotate self clockwise
func rotate_cw():
	self.rotation += PI / 2


## Rotate self counter-clockwise
func rotate_ccw():
	self.rotation -= PI / 2
