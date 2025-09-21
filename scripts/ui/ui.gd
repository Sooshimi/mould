extends Control

func _ready() -> void:
	TurnManager.connect("hp_updated", on_hp_updated)
	TurnManager.connect("max_hp_updated", on_max_hp_updated)
	TurnManager.connect("infected_cells_changed", on_infected_cells_changed)
	TurnManager.connect("infected_humans_changed", on_infected_humans_changed)
	TurnManager.connect("slime_round_start", on_slime_round)
	TurnManager.connect("enemy_round_start", on_enemy_round)
	TurnManager.connect("lose", on_lose)
	TurnManager.connect("win", on_win)
	TurnManager.connect("tutorial_start", update_infected_cells_bar)
	TurnManager.connect("game_start", update_infected_cells_bar)
	$NextLevelButton.hide()
	$RestartButton.hide()

func update_infected_cells_bar() -> void:
	$TopBar/InfectedCellsBar.max_value = TurnManager.total_cells

func on_hp_updated(hp: int) -> void:
	$TopBar/HBoxContainer/HPLabel.text = str(hp)
	$TopBar/HBoxContainer/HPBar.value = hp

func on_max_hp_updated(max_hp: int) -> void:
	$TopBar/HBoxContainer/HPBar.max_value = max_hp

func on_infected_cells_changed(total_infected_cells: int) -> void:
	$VBoxContainer/TotalInfectedCells.text = str("Total infected cells: ", total_infected_cells)
	$TopBar/InfectedCellsBar.value = total_infected_cells

func on_infected_humans_changed(total_infected_humans: int) -> void:
	$VBoxContainer/TotalInfectedHumans.text = str("Total infected humans: ", total_infected_humans)

func on_slime_round() -> void:
	$TurnLabel.text = "Player round"

func on_enemy_round() -> void:
	$TurnLabel.text = "Enemy round"

func on_lose() -> void:
	$TurnLabel.text = "You lost!"
	if TurnManager.current_level >= 1:
		TurnManager.current_level = 0
		$RestartButton.show()

func on_win() -> void:
	print(TurnManager.current_level)
	$TurnLabel.text = "You win!"
	if TurnManager.current_level == 2:
		$NextLevelButton.show()

func _on_next_level_button_pressed():
	TurnManager.next_level_button_clicked.emit()
	TurnManager.current_level = 2

func _on_restart_button_pressed():
	TurnManager.restart.emit()
