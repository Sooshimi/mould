extends CharacterBody2D
class_name Slime

@onready var sprite := $Sprite2D
@onready var up := $Up
@onready var down := $Down
@onready var left := $Left
@onready var right := $Right
@onready var slime_path := $"../SlimePath"

const tile_size := Vector2(35.0, 35.0)
var sprite_node_position_tween: Tween
var walk_speed := 0.3

var hp: int = 20:
	get:
		return hp
	set(new_value):
		hp = new_value
		TurnManager.slime_moved.emit(hp)
		TurnManager.deplete_slime_moves_left()

func _ready() -> void:
	slime_path.add_point(global_position)

func _physics_process(_delta: float) -> void:
	if (not sprite_node_position_tween or not sprite_node_position_tween.is_running()) and hp > 0:
		if Input.is_action_just_pressed("up") and not up.is_colliding():
			move(Vector2(0.0, -1.0))
		elif Input.is_action_just_pressed("down") and not down.is_colliding():
			move(Vector2(0.0, 1.0))
		elif Input.is_action_just_pressed("left") and not left.is_colliding():
			move(Vector2(-1.0, 0.0))
		elif Input.is_action_just_pressed("right") and not right.is_colliding():
			move(Vector2(1.0, 0.0))

func move(direction: Vector2) -> void:
	hp -= 1
	var target_position = global_position + (direction * tile_size)
	slime_path.add_point(target_position)
	
	# If there's an existing tween, terminate it. Prevents multiple tweens running at the same time.
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) # Sets Tween to update in sync with the physics frame step
	sprite_node_position_tween.tween_property(self, "global_position", target_position, walk_speed).set_trans(Tween.TRANS_SINE)
