extends Node2D

func _ready() -> void:
	TurnManager.connect("tutorial_start", start_at_tutorial)
	TurnManager.connect("game_start", start_game)
	$CanvasLayer.visible = false

func start_at_tutorial() -> void:
	$Camera2D.enabled = true
	$CanvasLayer.visible = true

func start_game() -> void:
	$Camera2D.enabled = false
