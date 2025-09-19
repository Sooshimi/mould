extends Node

enum TurnState {SLIME_TURN_START, SLIME_ACTION, SLIME_TURN_END, ENEMY_TURN_START, ENEMY_ACTION, ENEMY_TURN_END, END_GAME}
var current_state = TurnState.SLIME_TURN_START

var total_infected_cells: int = 0
var total_cells: int
var total_infected_humans: int = 0
var slime_moves_left := 5
var checked_hp: int

signal slime_round_start
signal slime_round_end
signal enemy_round_start
signal enemy_start_moving
signal enemy_round_end
signal win
signal lose

signal slime_moved(new_value) # used in Slime script
signal infected_cells_changed(new_value)
signal infected_humans_changed(new_value)

func start_game() -> void:
	slime_turn_start()

func slime_turn_start() -> void:
	print("slime turn start")
	current_state = TurnState.SLIME_TURN_START
	slime_moves_left = 5
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
	
	if checked_hp != 0:
		await get_tree().create_timer(1.0).timeout
		slime_turn_start()
	else:
		await get_tree().create_timer(1.0).timeout
		lose_end_game()

func check_hp(current_hp: int) -> void: # called from slime script
	checked_hp = current_hp

func lose_end_game() -> void:
	lose.emit() # updates UI
	current_state = TurnState.END_GAME

func increment_infected_cells(amount := 1) -> void:
	total_infected_cells += amount
	emit_signal("infected_cells_changed", total_infected_cells)

func increment_infected_humans(amount := 1) -> void:
	total_infected_humans += amount
	emit_signal("infected_humans_changed", total_infected_humans)

func deplete_slime_moves_left(amount := 1) -> void:
	slime_moves_left -= amount
	if slime_moves_left == 0:
		slime_turn_end()
