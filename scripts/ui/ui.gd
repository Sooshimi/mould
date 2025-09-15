extends Control

@onready var dice_rolled_label := $DiceRolledLabel
@onready var player_moves_left_label := $SlimeMovesRemainingLabel

func _ready() -> void:
	TurnManager.connect("dice_rolled", on_dice_rolled)
	TurnManager.connect("slime_moved", on_slime_move)

func on_dice_rolled(new_value: int) -> void:
	dice_rolled_label.text = str("Rolled value is ", new_value)

func on_slime_move(moves_left: int) -> void:
	player_moves_left_label.text = str("Slime moves left: ", moves_left)
