extends Control

const dialogue = [
	"",
	"Try moving with WASD or the arrow keys!",
	"Great! Did you notice the top red HP bar go down? It goes down by 1 HP every time you move, so watch your HP!\n\nFor every 5 moves you make, humans on the board will move 1 square too!\n\nYou can infect a piece of the ground by moving around all its edges. Try it!",
	"Nice job, you just infected your first bit of ground! This is also indicated by the green bar at the top, just below your HP bar.\n\nThe aim of the game is to infect 50% of the ground. You can also infect humans by moving around the uninfected ground they're stood on. Infected humans can spread the infection, so they will be useful!\n\nTry infecting another ground, or a human!",
	"Perfect. There's a few more things to mention:\n\n- Wolves can kill humans. You can kill wolves by moving around the ground they're stood on.\n\n- You can gain HP by infecting humans, and for every 2 cells infected!"
]

var current_dialogue_index := 0
var tutorial_step := 0

func _ready() -> void:
	next_dialogue()
	TurnManager.connect("tutorial_start", update_dialogue)
	TurnManager.connect("hp_updated", step_1_player_moved)
	TurnManager.connect("infected_cells_changed", step_3_infect_cell)
	#TurnManager.connect("infected_humans_changed", on_infected_humans_changed)
	$DialogueBox/NextButton.hide()

func update_dialogue() -> void:
	if current_dialogue_index < dialogue.size():
		$DialogueBox/DialogueText.text = dialogue[current_dialogue_index]
		if current_dialogue_index == dialogue.size() - 1:
			$DialogueBox/NextButton.hide()

func _on_skip_tutorial_button_pressed():
	TurnManager.stop_slime_move.emit(false)
	TurnManager.current_level = 1
	TurnManager.start_game()
	$SkipTutorialButton.hide()
	$DialogueBox.hide()

func step_1_player_moved(_new_value) -> void:
	if TurnManager.current_level != 1:
		if tutorial_step < 2:
			tutorial_step += 1
		if tutorial_step == 2:
			next_dialogue()
			pause_and_create_next_button_timer()

func step_3_infect_cell(_new_value) -> void:
	if TurnManager.current_level != 1:
		tutorial_step += 1
		next_dialogue()
		pause_and_create_next_button_timer()

func pause_and_create_next_button_timer() -> void:
	TurnManager.stop_slime_move.emit(true)
	await get_tree().create_timer(2.0).timeout
	$DialogueBox/NextButton.show()

func next_dialogue() -> void:
	current_dialogue_index += 1
	update_dialogue()

func _on_next_button_pressed():
	TurnManager.stop_slime_move.emit(false)
	$DialogueBox/NextButton.hide()
	tutorial_step += 1
