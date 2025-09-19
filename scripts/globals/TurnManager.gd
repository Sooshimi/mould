extends Node

enum Turn {Slime, Enemy}

var current_turn = Turn.Slime

var total_infected_cells: int = 0
var total_cells: int
var total_infected_humans: int = 0
var slime_moves_left := 5

signal player_round_end
signal slime_moved(new_value)
signal infected_cells_changed(new_value)
signal infected_humans_changed(new_value)

func increment_infected_cells(amount := 1) -> void:
	total_infected_cells += amount
	emit_signal("infected_cells_changed", total_infected_cells)

func increment_infected_humans(amount := 1) -> void:
	total_infected_humans += amount
	emit_signal("infected_humans_changed", total_infected_humans)

func deplete_slime_moves_left(amount := 1) -> void:
	slime_moves_left -= amount
	if slime_moves_left == 0:
		player_round_end.emit()
		current_turn = Turn.Enemy
