extends Control

@onready var main_menu = $"."

func _on_start_game_button_pressed() -> void:
	main_menu.hide()
	SceneManager.start_button_click.emit()
