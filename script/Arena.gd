extends Node2D

## Current active tetromino, could be null if it was not spawned in time
var active_tetromino: Tetromino

signal locked_down(tetro: Tetromino)

const ARENA_WIDTH: int = 10
const ARENA_HEIGHT: int = 20
const ARENA_WIDTH_PIXEL: float = ARENA_WIDTH * TetroBlock.BLOCK_SIZE
const ARENA_HEIGHT_PIXEL: float = ARENA_HEIGHT * TetroBlock.BLOCK_SIZE


# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
	self.setup_cell_manager()
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
		_debug_print()
	if event.is_action_pressed("tetro_move_right", true):
		self.try_move_right(active_tetromino)
		_debug_print()
	if event.is_action_pressed("tetro_soft_drop", true):
		# Stop and restart the timer to avoid accelaration
		$TetrominoDropTimer.stop()
		self.try_move_down(active_tetromino)
		$TetrominoDropTimer.start()
		_debug_print()
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
	var src_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	tetro.move_left()
	var dest_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	$CellManager.move_tetro_cells(tetro, src_cell_positions, dest_cell_positions)


func try_move_right(tetro: Tetromino):
	# TODO Check boundary
	var src_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	tetro.move_right()
	var dest_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	$CellManager.move_tetro_cells(tetro, src_cell_positions, dest_cell_positions)


func try_move_down(tetro: Tetromino):
	# TODO Check boundary
	var src_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	tetro.move_down()
	var dest_cell_positions = CellManager.get_cell_positions_of_tetro(tetro)
	$CellManager.move_tetro_cells(tetro, src_cell_positions, dest_cell_positions)


func try_rotate_cw(tetro: Tetromino):
	# TODO Check boundary
	tetro.rotate_cw()


func try_rotate_ccw(tetro: Tetromino):
	# TODO Check boundary
	tetro.rotate_ccw()


func setup_cell_manager():
	$CellManager.cell_width = ARENA_WIDTH
	$CellManager.cell_height = ARENA_HEIGHT
	$CellManager.cells.resize(ARENA_WIDTH * ARENA_HEIGHT)
	$CellManager.cells.fill(null)


## Setup active_tetromino
## First spawn a random tetromino, then put it to a designated spawn point
func setup_active_tetromino():
	active_tetromino = $TetrominoSpawner.spawn_random()
	self.add_child(active_tetromino)
	active_tetromino.position = $TetrominoSpawner.get_spawn_position_for(
		active_tetromino, ARENA_WIDTH
	)
	$CellManager.set_tetro_cells(active_tetromino)
	_debug_print()
	print("[1]Spawn ", active_tetromino)


func _on_tetromino_drop_timer_timeout():
	# TODO Debug
	# active_tetromino.move_down()
	pass


func _debug_print():
	if active_tetromino != null:
		active_tetromino._debug_print()
	$CellManager._debug_print()
