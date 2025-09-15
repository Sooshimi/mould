extends CharacterBody2D
class_name Human

@onready var sprite := $Sprite2D
@onready var up := $Up
@onready var down := $Down
@onready var left := $Left
@onready var right := $Right

const tile_size := Vector2(17.0, 17.0)
var sprite_node_position_tween: Tween
var walk_speed := 0.3
var direction: Vector2
var infected := false

func _ready() -> void:
	TurnManager.connect("dice_rolled", on_dice_rolled)
	
func on_dice_rolled(_new_value) -> void:
	move()

func pick_random_direction() -> Vector2:
	var directions := [Vector2(0.0, -1.0), Vector2(0.0, 1.0), Vector2(-1.0, 0.0), Vector2(1.0, 0.0)] # Up, Down, Left, Right
	
	if up.is_colliding():
		directions.remove_at(0)
	if down.is_colliding():
		directions.remove_at(1)
	if left.is_colliding():
		directions.remove_at(2)
	if right.is_colliding():
		directions.remove_at(3)
	
	direction = directions[randi() % directions.size()]
	
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
