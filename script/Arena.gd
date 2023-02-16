extends Node2D

var active_tetromino: Tetromino
var arena_cells: Array[TetroBlock]

const ARENA_WIDTH: int = 10
const ARENA_WIDTH_PIXEL: float = ARENA_WIDTH * TetroBlock.BLOCK_SIZE
const ARENA_HEIGHT: int = 20
const ARENA_HEIGHT_PIXEL: float = ARENA_HEIGHT * TetroBlock.BLOCK_SIZE
const SPAWN_POINT: Vector2 = Vector2(ARENA_WIDTH_PIXEL / 2.0, TetroBlock.BLOCK_SIZE)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	# TODO
	active_tetromino = $TetrominoSpawner.spawn_random()
	self.add_child(active_tetromino)
	active_tetromino.position = SPAWN_POINT
	print("[1]Spawn ", active_tetromino)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _input(event):
	if active_tetromino != null:
		try_move_tetromino(event)


func try_move_tetromino(event: InputEvent) -> void:
	# Set "allow_echo" to true so when player holds these key they can still move tetrominos
	# TODO Set a custome timeout to action hold time
	if event.is_action_pressed("tetro_move_left", true):
		print("todo, move left ", active_tetromino)
	if event.is_action_pressed("tetro_move_right", true):
		print("todo, move right ", active_tetromino)
	if event.is_action_pressed("tetro_soft_drop", true):
		print("todo, soft drop ", active_tetromino)
	if event.is_action_pressed("tetro_hard_drop"):
		print("todo, hard drop ", active_tetromino)
	if event.is_action_pressed("tetro_rotate_cw"):
		print("todo, rotate clockwise ", active_tetromino)
	if event.is_action_pressed("tetro_rotate_ccw"):
		print("todo, rotate counter-clockwise ", active_tetromino)
	if event.is_action_pressed("tetro_hold"):
		print("todo, hold ", active_tetromino)
