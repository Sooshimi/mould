extends Node

func _ready() -> void:
	SceneManager.start_button_click.connect(show_game)

func show_game() -> void:
	$Game.show()
