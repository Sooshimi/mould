extends Node

var first_level = preload("res://scenes/game_8x8.tscn")
var new_level = preload("res://scenes/game_16x16.tscn")

func _ready() -> void:
	SceneManager.start_button_click.connect(show_game)
	$MainLoopMusic.play()
	TurnManager.connect("next_level_button_clicked", next_level)
	TurnManager.connect("restart", restart)

func show_game() -> void:
	#$GameWindow/Game.show()
	$Atmos.play()

func _on_main_loop_music_finished() -> void:
	$MainLoopMusic.play()

func _on_atmos_finished() -> void:
	$Atmos.play()

func next_level() -> void:
	$GameWindow/Game.queue_free()
	var level_2 = new_level.instantiate()
	$GameWindow.add_child(level_2)
	if TurnManager.current_level == 1:
		TurnManager.current_level = 2
	elif TurnManager.current_level == 2:
		TurnManager.current_level = 3
	TurnManager.start_game()
	TurnManager.stop_slime_move.emit(false)

func restart() -> void:
	get_tree().reload_current_scene()
