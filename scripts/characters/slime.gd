extends CharacterBody2D
class_name Slime

@onready var up := $Up
@onready var down := $Down
@onready var left := $Left
@onready var right := $Right
@onready var slime_path := $"../SlimePath"
@onready var slime_move_sfx := $SlimeMoveSFX

var slime_move_sfx_list = [
	preload("res://audio/SFX/fungi_movement/move_1.wav"),
	preload("res://audio/SFX/fungi_movement/move_2.wav"),
	preload("res://audio/SFX/fungi_movement/move_3.wav"),
	preload("res://audio/SFX/fungi_movement/move_4.wav"),
	preload("res://audio/SFX/fungi_movement/move_5.wav"),
	preload("res://audio/SFX/fungi_movement/move_6.wav"),
	preload("res://audio/SFX/fungi_movement/move_7.wav"),
	preload("res://audio/SFX/fungi_movement/move_8.wav"),
	preload("res://audio/SFX/fungi_movement/move_9.wav"),
	preload("res://audio/SFX/fungi_movement/move_10.wav"),
	preload("res://audio/SFX/fungi_movement/move_11.wav")
]

const tile_size := Vector2(32.0, 32.0)
var sprite_node_position_tween: Tween
var walk_speed := 0.3
var max_hp: int = 20
var hp = max_hp:
	get:
		return hp
	set(new_value):
		if new_value < hp:
			TurnManager.deplete_slime_moves_left()
		hp = new_value
		TurnManager.hp_updated.emit(hp)
		TurnManager.check_hp(hp)
var disable_move := false

func _ready() -> void:
	slime_path.add_point(global_position)
	TurnManager.connect("infected_humans_changed", increase_hp_from_humans)
	TurnManager.connect("increase_hp_from_infected_cells", increase_hp_from_cells)
	TurnManager.connect("stop_slime_move", disable_movement)
	TurnManager.max_hp_updated.emit(max_hp)
	TurnManager.hp_updated.emit(hp)

func increase_hp_from_cells() -> void:
	hp = min(hp + 5, max_hp)
	TurnManager.max_hp_updated.emit(max_hp)

func increase_hp_from_humans(_new_value) -> void:
	max_hp += 1
	hp = min(hp + 5, max_hp)

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
	if TurnManager.current_state == 1 and !disable_move:
		hp -= 1
		TurnManager.check_slime_moves_and_hp_left()
		var target_position = global_position + (direction * tile_size)
		slime_path.add_point(target_position)
		
		# If there's an existing tween, terminate it. Prevents multiple tweens running at the same time.
		if sprite_node_position_tween:
			sprite_node_position_tween.kill()
		sprite_node_position_tween = create_tween()
		sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) # Sets Tween to update in sync with the physics frame step
		sprite_node_position_tween.tween_property(self, "global_position", target_position, walk_speed).set_trans(Tween.TRANS_SINE)
		
		var random_sfx_index = randi() % slime_move_sfx_list.size()
		slime_move_sfx.stream = slime_move_sfx_list[random_sfx_index]
		slime_move_sfx.play()

func disable_movement(toggle: bool) -> void:
	print("paused", toggle)
	disable_move  = toggle
