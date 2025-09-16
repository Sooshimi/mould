extends Node

enum Phase {GAME_TUTORIAL, GAME_LEVEL_1}

var current_phase: int = Phase.GAME_TUTORIAL

signal start_button_click

func change_to_state(state: int) -> void:
	if state == 0:
		current_phase = Phase.GAME_TUTORIAL
	if state == 1:
		current_phase = Phase.GAME_LEVEL_1
