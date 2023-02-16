extends Node2D

var active_tetromino: Tetromino

# One dimension array for our 20 * 10 cells arena
var arena_cells: Array[TetroBlock]

const ARENA_WIDTH: int = 10
const ARENA_WIDTH_PIXEL: float = ARENA_WIDTH * TetroBlock.BLOCK_SIZE
const ARENA_HEIGHT: int = 20
const ARENA_HEIGHT_PIXEL: float = ARENA_HEIGHT * TetroBlock.BLOCK_SIZE

## The initial tetromino spawn point is in the top middle of this arena
const SPAWN_POINT: Vector2 = Vector2(ARENA_WIDTH_PIXEL / 2.0, TetroBlock.BLOCK_SIZE)


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	self.setup_active_tetromino()


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
		active_tetromino.move_left()
	if event.is_action_pressed("tetro_move_right", true):
		print("todo, move right ", active_tetromino)
		active_tetromino.move_right()
	if event.is_action_pressed("tetro_soft_drop", true):
		print("todo, soft drop ", active_tetromino)
		# Stop and restart the timer to avoid accelaration
		$TetrominoDropTimer.stop()
		active_tetromino.move_down()
		$TetrominoDropTimer.start()
	if event.is_action_pressed("tetro_hard_drop"):
		print("todo, hard drop ", active_tetromino)
	if event.is_action_pressed("tetro_rotate_cw"):
		print("todo, rotate clockwise ", active_tetromino)
		active_tetromino.rotate_cw()
	if event.is_action_pressed("tetro_rotate_ccw"):
		print("todo, rotate counter-clockwise ", active_tetromino)
		active_tetromino.rotate_ccw()
	if event.is_action_pressed("tetro_hold"):
		print("todo, hold ", active_tetromino)


func setup_active_tetromino():
	active_tetromino = $TetrominoSpawner.spawn_random()
	self.add_child(active_tetromino)
	active_tetromino.position = SPAWN_POINT
	print("[1]Spawn ", active_tetromino)


func _on_tetromino_drop_timer_timeout():
	active_tetromino.move_down()
