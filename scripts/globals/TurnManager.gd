extends Node

enum TurnState {SLIME_TURN_START, SLIME_ACTION, SLIME_TURN_END, ENEMY_TURN_START, ENEMY_ACTION, ENEMY_TURN_END, END_GAME}
var current_state = TurnState.SLIME_TURN_START

const level_1_total_cells := 8
const level_2_total_cells := 16
const level_2_infected_cells_target := 192 # out of 256 (75%)

var total_infected_cells: int
var total_infected_humans: int
const slime_moves_left_default := 5
var slime_moves_left: int
var checked_hp: int = 1 # so it doesn't trigger check_slime_moves_and_hp_left() on game start

signal slime_round_start
signal slime_round_end
signal enemy_round_start
signal enemy_start_moving
signal enemy_round_end
signal win
signal lose

signal hp_updated(new_value) # used in Slime script
signal infected_cells_changed(new_value)
signal infected_humans_changed(new_value)

func start_game() -> void:
	slime_turn_start()
	total_infected_cells = 0
	total_infected_humans = 0

func slime_turn_start() -> void:
	print("slime turn start")
	current_state = TurnState.SLIME_TURN_START
	slime_moves_left = slime_moves_left_default
	slime_round_start.emit() # Update UI text
	
	await get_tree().create_timer(1.0).timeout
	slime_action()

func slime_action() -> void:
	print("slime action")
	current_state = TurnState.SLIME_ACTION

func slime_turn_end() -> void:
	print("slime turn end")
	current_state = TurnState.SLIME_TURN_END
	
	await get_tree().create_timer(1.0).timeout
	enemy_turn_start()

func enemy_turn_start() -> void:
	print("enemy turn start")
	current_state = TurnState.ENEMY_TURN_START
	enemy_round_start.emit() # Update UI text
	
	await get_tree().create_timer(1.0).timeout
	enemy_action()

func enemy_action() -> void:
	print("enemy action")
	current_state = TurnState.ENEMY_ACTION
	enemy_start_moving.emit()

func enemy_turn_end() -> void:
	print("enemy turn end")
	# Enemy script to call this func
	current_state = TurnState.ENEMY_TURN_END
	
	await get_tree().create_timer(1.0).timeout
	
	if checked_hp == 0 and (total_infected_cells < level_2_infected_cells_target):
		lose_end_game()
	elif checked_hp >= 0 and (total_infected_cells >= level_2_infected_cells_target):
		win_end_game()
	else:
		slime_turn_start()

func check_hp(current_hp: int) -> void: # called from slime script
	checked_hp = current_hp

func lose_end_game() -> void:
	lose.emit() # updates UI
	current_state = TurnState.END_GAME

func win_end_game() -> void:
	win.emit() # updates UI
	current_state = TurnState.END_GAME

func increment_infected_cells(amount := 1) -> void:
	total_infected_cells += amount
	emit_signal("infected_cells_changed", total_infected_cells)

func increment_infected_humans(amount := 1) -> void:
	total_infected_humans += amount
	emit_signal("infected_humans_changed", total_infected_humans)

func deplete_slime_moves_left(amount := 1) -> void:
	slime_moves_left -= amount
	check_slime_moves_and_hp_left()

func check_slime_moves_and_hp_left() -> void:
	if slime_moves_left == 0 or checked_hp == 0:
		slime_turn_end()
