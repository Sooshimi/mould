extends Node

func _ready() -> void:
	SceneManager.start_button_click.connect(show_game)
	$MainLoopMusic.play()

func show_game() -> void:
	$Game.show()
	$Atmos.play()

func _on_main_loop_music_finished():
	$MainLoopMusic.play()

func _on_atmos_finished():
	$Atmos.play()
