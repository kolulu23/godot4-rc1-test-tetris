extends Node

func _ready() -> void:
	$Arena.game_over.connect(_on_game_over)

func _input(event):
	if event.is_action_pressed("restart"):
		$HUD.visible = false
		self.get_tree().reload_current_scene()

func _on_game_over():
	$HUD.visible = true
