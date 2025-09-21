extends Node2D

func _ready() -> void:
	TurnManager.connect("tutorial_start", start_at_tutorial)
	TurnManager.connect("game_start", start_game)
	
	if TurnManager.current_level == 0:
		$CanvasLayer.visible = false
	elif TurnManager.current_level == 2:
		$CanvasLayer.visible = true

func start_at_tutorial() -> void:
	if TurnManager.current_level == 0:
		$TutorialCamera.enabled = true
		$CanvasLayer.visible = true

func start_game() -> void:
	if TurnManager.current_level == 1:
		$"8x8Camera".enabled = true
		$TutorialCamera.enabled = false
	$CanvasLayer.visible = true
