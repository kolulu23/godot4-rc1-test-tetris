extends Node2D

## Current active tetromino, could be null if it was not spawned in time
var active_tetromino: Tetromino

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


func _physics_process(delta):
	pass


func _input(event):
	if active_tetromino != null:
		try_move_tetromino(event)


func try_move_tetromino(event: InputEvent) -> void:
	# Set "allow_echo" to true so when player holds these key they can still move tetrominos
	var moved: bool = false
	if event.is_action_pressed("tetro_move_left", true):
		moved = $CellManager.move_tetro_cells_to(active_tetromino, Vector2i.LEFT)
	if event.is_action_pressed("tetro_move_right", true):
		moved = $CellManager.move_tetro_cells_to(active_tetromino, Vector2i.RIGHT)
	if event.is_action_pressed("tetro_soft_drop", true):
		# Stop and restart the timer to avoid accelaration
		$TetrominoDropTimer.stop()
		moved = $CellManager.move_tetro_cells_to(active_tetromino, Vector2i.DOWN)
		$TetrominoDropTimer.start()
		if not moved and $TetrominoLockDownTimer.is_stopped():
			$TetrominoLockDownTimer.start()
	if event.is_action_pressed("tetro_hard_drop"):
		print("todo, hard drop ", active_tetromino)
	if event.is_action_pressed("tetro_rotate_cw"):
		moved = $CellManager.rotate_tetro_cells_to(active_tetromino, PI / 2)
	if event.is_action_pressed("tetro_rotate_ccw"):
		moved = $CellManager.rotate_tetro_cells_to(active_tetromino, -PI / 2)
	if event.is_action_pressed("tetro_hold"):
		print("todo, hold ", active_tetromino)
	if moved:
		_debug_print()


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
	var cell_positions = CellManager.get_cell_positions_of_tetro(active_tetromino)
	if $CellManager.is_tetro_can_move_to(active_tetromino, cell_positions):
		$CellManager.set_tetro_cells(active_tetromino)
	else:
		print("[TODO]Game Over")
	_debug_print()
	print("[1]Spawn ", active_tetromino)


func _on_tetromino_drop_timer_timeout():
	# TODO Debug
	# if not $CellManager.move_tetro_cells_to(active_tetromino, Vector2i.DOWN):
	# 	$TetrominoLockDownTimer.start()
	pass


## This is a one shot timer, we start it manually
func _on_tetromino_lock_down_timer_timeout():
	print(active_tetromino, " locked down")
	self.setup_active_tetromino()


func _debug_print():
	if active_tetromino != null:
		active_tetromino._debug_print()
	$CellManager._debug_print()
