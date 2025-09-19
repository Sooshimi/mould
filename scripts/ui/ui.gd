extends Control

func _ready() -> void:
	TurnManager.connect("slime_moved", on_slime_move)
	TurnManager.connect("infected_cells_changed", on_infected_cells_changed)
	TurnManager.connect("infected_humans_changed", on_infected_humans_changed)
	TurnManager.connect("slime_round_start", on_slime_round)
	TurnManager.connect("enemy_round_start", on_enemy_round)
	TurnManager.connect("lose", on_lose)

func on_slime_move(hp: int) -> void:
	$VBoxContainer/SlimeMovesRemainingLabel.text = str("HP: ", hp)

func on_infected_cells_changed(total_infected_cells: int) -> void:
	$VBoxContainer/TotalInfectedCells.text = str("Total infected cells: ", total_infected_cells)

func on_infected_humans_changed(total_infected_humans: int) -> void:
	$VBoxContainer/TotalInfectedHumans.text = str("Total infected humans: ", total_infected_humans)

func on_slime_round() -> void:
	$TurnLabel.text = "Player round"

func on_enemy_round() -> void:
	$TurnLabel.text = "Enemy round"

func on_lose() -> void:
	$TurnLabel.text = "You lost!"
