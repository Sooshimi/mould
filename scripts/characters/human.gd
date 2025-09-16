extends CharacterBody2D
class_name Human

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
var infected := false

func _ready() -> void:
	TurnManager.connect("dice_rolled", on_dice_rolled)
	
func on_dice_rolled(_new_value) -> void:
	move()

func pick_random_direction() -> Vector2:
	var directions := [move_up, move_down, move_left, move_right] # Up, Down, Left, Right
	
	if up.is_colliding():
		directions.erase(move_up)
	if down.is_colliding():
		directions.erase(move_down)
	if left.is_colliding():
		directions.erase(move_left)
	if right.is_colliding():
		directions.erase(move_right)
	
	if directions.size() > 0:
		direction = directions[randi() % directions.size()]
	else:
		direction = Vector2.ZERO
	
	return direction

func move() -> void:
	direction = pick_random_direction()
	var target_position = global_position + (direction * tile_size)
	
	# If there's an existing tween, terminate it. Prevents multiple tweens running at the same time.
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) # Sets Tween to update in sync with the physics frame step
	sprite_node_position_tween.tween_property(self, "global_position", target_position, walk_speed).set_trans(Tween.TRANS_SINE)
