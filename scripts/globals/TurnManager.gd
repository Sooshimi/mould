extends Node

var total_infected_cells: int = 0
var total_cells: int
var total_infected_humans: int = 0

signal dice_rolled(new_value)
signal slime_moved(moves_left)
signal infected_cells_changed(new_value)
signal infected_humans_changed(new_value)

func increment_infected_cells(amount := 1) -> void:
	total_infected_cells += amount
	emit_signal("infected_cells_changed", total_infected_cells)

func increment_infected_humans(amount := 1) -> void:
	total_infected_humans += amount
	emit_signal("infected_humans_changed", total_infected_humans)
