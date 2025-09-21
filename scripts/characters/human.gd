extends AI
class_name Human

var caught_by_wolf := false
var die_next_turn := false
var infected := false:
	set(is_true):
		if !infected and is_true:
			TurnManager.increment_infected_humans()
		infected = is_true

func infected_colour() -> void:
	$Sprite2D.texture = preload("res://assets/infected_human_counter.png")

func pick_direction() -> Vector2:
	if not caught_by_wolf:
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
	else:
		return Vector2.ZERO

func move() -> void:
	direction = pick_direction()
	var target_position = global_position + (direction * tile_size)
	
	# If there's an existing tween, terminate it. Prevents multiple tweens running at the same time.
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) # Sets Tween to update in sync with the physics frame step
	sprite_node_position_tween.tween_property(self, "global_position", target_position, walk_speed).set_trans(Tween.TRANS_SINE)
	TurnManager.enemy_turn_end()

func _on_killed_area_body_entered(body: Wolf):
	body.play_kill_audio()
	queue_free()

func _on_detect_area_body_entered(_body: Wolf) -> void:
	caught_by_wolf = true

func _on_detect_area_body_exited(_body: Wolf):
	caught_by_wolf = false
