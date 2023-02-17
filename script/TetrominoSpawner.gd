## Tetromino Spawner, provides the ability to spawn any tetromino
##
## For random spawning, it uses the 7-bag method to present tetrominos to players.
## See [url={https://tetris.wiki/Random_Generator}]Random Generator[/url].
extends Node
class_name TetrominoSpawner

## If set to true, this spawner will use the same tetro bag as the first bag uses between games
@export var first_bag_fixed: bool = true

## Tetromino bag stores 7 tetromino at max, will replenish itself when it's emptied out
var tetro_bag: Array[int]


func _ready():
	self.replenish_tetromino_bag()
	if !first_bag_fixed:
		tetro_bag.shuffle()


## Spawn a specific type of tetromino
func spawn(tetro_type: Tetromino.TetroType) -> Tetromino:
	var tetro_scene: Resource
	match tetro_type:
		Tetromino.TetroType.I:
			tetro_scene = preload("res://Tetromino/Tetro_I.tscn")
		Tetromino.TetroType.J:
			tetro_scene = preload("res://Tetromino/Tetro_J.tscn")
		Tetromino.TetroType.L:
			tetro_scene = preload("res://Tetromino/Tetro_L.tscn")
		Tetromino.TetroType.O:
			tetro_scene = preload("res://Tetromino/Tetro_O.tscn")
		Tetromino.TetroType.S:
			tetro_scene = preload("res://Tetromino/Tetro_S.tscn")
		Tetromino.TetroType.T:
			tetro_scene = preload("res://Tetromino/Tetro_T.tscn")
		Tetromino.TetroType.Z:
			tetro_scene = preload("res://Tetromino/Tetro_Z.tscn")
	var tetro = tetro_scene.instantiate()
	tetro.tetro_type = tetro_type
	return tetro


## Randomly spawn a tetromino using the algorithm described at class doc section
func spawn_random() -> Tetromino:
	if tetro_bag.is_empty():
		self.replenish_tetromino_bag(true)
	var tetro_type: Tetromino.TetroType = tetro_bag.pop_back()
	return spawn(tetro_type)


## Reset [member tetro_bag] with 7 different tetrominos.
## If [code]shuffle[/code] is true, it will randomize tetro_bag items but each item is still unique [br]
## [b]Note[/b]: This method does not check the emptiness of [member tetro_bag]
func replenish_tetromino_bag(shuffle := false) -> void:
	tetro_bag = [
		Tetromino.TetroType.Z,
		Tetromino.TetroType.O,
		Tetromino.TetroType.S,
		Tetromino.TetroType.T,
		Tetromino.TetroType.L,
		Tetromino.TetroType.I,
		Tetromino.TetroType.J,
	]
	if shuffle:
		tetro_bag.shuffle()


## Get the spawn position for a specific tetromino type within the arena.
## All tetromino must have their position.x equals to multiple TetroBlock.BLOCK_SIZE plus an offset.
## This ensures all movement based on TetroBlock.BLOCK_SIZE not go out of arena.
func get_spawn_position_for(tetro: Tetromino, arena_width: int) -> Vector2:
	var offset_x: float
	var offset_y: float
	match tetro.tetro_type:
		Tetromino.TetroType.I, Tetromino.TetroType.O:
			offset_x = 0.
			offset_y = TetroBlock.BLOCK_SIZE
		_:
			offset_x = TetroBlock.BLOCK_SIZE_HALF
			offset_y = TetroBlock.BLOCK_SIZE_HALF + TetroBlock.BLOCK_SIZE
	var arena_top_middle: float = TetroBlock.BLOCK_SIZE * arena_width / 2.0
	return Vector2(arena_top_middle + offset_x, offset_y)