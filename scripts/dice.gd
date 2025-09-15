extends Node2D

var dice_faces = [
	preload("res://assets/dice/dieWhite_border1.png"),
	preload("res://assets/dice/dieWhite_border2.png"),
	preload("res://assets/dice/dieWhite_border3.png"),
	preload("res://assets/dice/dieWhite_border4.png"),
	preload("res://assets/dice/dieWhite_border5.png"),
	preload("res://assets/dice/dieWhite_border6.png")
]

@onready var face := $Face
@onready var roll_timer := $RollTimer

var current_face: int:
	get:
		return current_face
	set(value):
		current_face = value
		TurnManager.dice_rolled.emit(current_face+1)

func _process(_delta: float) -> void:
	roll_dice()

func _on_button_pressed() -> void:
	roll_timer.start()

func roll_dice() -> void:
	if not roll_timer.is_stopped():
		current_face = randi_range(0, 5)
		face.texture = dice_faces[current_face]
