extends Node2D

## Current active tetromino, could be null if it was not spawned in time
var active_tetromino: Tetromino

## One dimension array for our 20 * 10 cells arena
var arena_cells: Array[TetroBlock]

signal locked_down(tetro: Tetromino)

const ARENA_WIDTH: int = 10
const ARENA_HEIGHT: int = 20
const ARENA_WIDTH_PIXEL: float = ARENA_WIDTH * TetroBlock.BLOCK_SIZE
const ARENA_HEIGHT_PIXEL: float = ARENA_HEIGHT * TetroBlock.BLOCK_SIZE


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
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
		self.try_move_left(active_tetromino)
	if event.is_action_pressed("tetro_move_right", true):
		self.try_move_right(active_tetromino)
	if event.is_action_pressed("tetro_soft_drop", true):
		# Stop and restart the timer to avoid accelaration
		$TetrominoDropTimer.stop()
		self.try_move_down(active_tetromino)
		$TetrominoDropTimer.start()
	if event.is_action_pressed("tetro_hard_drop"):
		print("todo, hard drop ", active_tetromino)
	if event.is_action_pressed("tetro_rotate_cw"):
		self.try_rotate_cw(active_tetromino)
	if event.is_action_pressed("tetro_rotate_ccw"):
		self.try_rotate_ccw(active_tetromino)
	if event.is_action_pressed("tetro_hold"):
		print("todo, hold ", active_tetromino)


func try_move_left(tetro: Tetromino):
	# TODO Check boundary
	active_tetromino.move_left()


func try_move_right(tetro: Tetromino):
	# TODO Check boundary
	active_tetromino.move_right()


func try_move_down(tetro: Tetromino):
	# TODO Check boundary
	active_tetromino.move_down()


func try_rotate_cw(tetro: Tetromino):
	# TODO Check boundary
	active_tetromino.rotate_cw()


func try_rotate_ccw(tetro: Tetromino):
	# TODO Check boundary
	active_tetromino.rotate_ccw()


## Setup active_tetromino
## First spawn a random tetromino, then rotate it randomly, then put it to a designated spawn point
func setup_active_tetromino():
	active_tetromino = $TetrominoSpawner.spawn_random()
	self.add_child(active_tetromino)
	for i in randi() % 3:
		active_tetromino.rotate_cw()
	var spawn_position = $TetrominoSpawner.get_spawn_position_for(active_tetromino, ARENA_WIDTH)
	active_tetromino.position = spawn_position
	print("[1]Spawn ", active_tetromino)


func _on_tetromino_drop_timer_timeout():
	active_tetromino.move_down()
