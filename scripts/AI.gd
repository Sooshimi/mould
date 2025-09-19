@abstract class_name AI extends CharacterBody2D
@abstract func pick_direction() -> Vector2
@abstract func move() -> void

@onready var detect_area := $DetectArea
@onready var sprite := $Sprite2D
@onready var up := $Up
@onready var down := $Down
@onready var left := $Left
@onready var right := $Right

const tile_size := Vector2(35.0, 35.0)
const move_up := Vector2(0.0, -1.0)
const move_down := Vector2(0.0, 1.0)
const move_left := Vector2(-1.0, 0.0)
const move_right := Vector2(1.0, 0.0)
var sprite_node_position_tween: Tween
var walk_speed := 0.3
var direction: Vector2

func _ready() -> void:
	TurnManager.connect("player_round_end", on_player_round_end)

func on_player_round_end() -> void:
	move()
