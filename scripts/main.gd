extends Node

var first_level = preload("res://scenes/game_8x8.tscn")
var new_level = preload("res://scenes/game_16x16.tscn")

func _ready() -> void:
	SceneManager.start_button_click.connect(show_game)
	$MainLoopMusic.play()
	TurnManager.connect("next_level_button_clicked", next_level)
	TurnManager.connect("game_start", stop_all_sfx)
	TurnManager.connect("restart", restart)
	TurnManager.connect("wolf_die", wolf_die_sfx)
	TurnManager.connect("win", win_sfx)
	TurnManager.connect("lose", lose_sfx)
	$GameWindow/Game.hide()

func show_game() -> void:
	$GameWindow/Game.show()
	$Atmos.play()

func _on_main_loop_music_finished() -> void:
	$MainLoopMusic.play()

func _on_atmos_finished() -> void:
	$Atmos.play()

func next_level() -> void:
	$MainLoopMusic.play()
	$Atmos.play()
	$GameWindow/Game.queue_free()
	var level_2 = new_level.instantiate()
	$GameWindow.add_child(level_2)
	if TurnManager.current_level == 1:
		TurnManager.current_level = 2
	#elif TurnManager.current_level == 2:
		#TurnManager.current_level = 3
	TurnManager.start_game()
	TurnManager.stop_slime_move.emit(false)

func restart() -> void:
	get_tree().reload_current_scene()

func wolf_die_sfx() -> void:
	$WolfDieSFX.play()

func win_sfx() -> void:
	$WinSFX.play()
	$MainLoopMusic.volume_db = -80.0
	$Atmos.volume_db = -80.0

func lose_sfx() -> void:
	$LoseSFX.play()
	$MainLoopMusic.volume_db = -80.0
	$Atmos.volume_db = -80.0

func stop_all_sfx() -> void:
	$WinSFX.stop()
	$LoseSFX.stop()
	$MainLoopMusic.volume_db = -15.743
	$Atmos.volume_db = -15.743
