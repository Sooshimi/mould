extends AI
class_name Wolf

var humans_detected := []
var human_to_chase: Human

func pick_direction() -> Vector2:
	if humans_detected.size() > 0:
		human_to_chase = humans_detected[0]
		var target := human_to_chase.global_position
		var delta = target - global_position
		if abs(delta.x) > abs(delta.y):
			if delta.x > 0:
				return move_right
			else:
				return move_left
		else:
			if delta.y > 0:
				return move_down
			else:
				return move_up
	else:
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
	direction = pick_direction()
	var target_position = global_position + (direction * tile_size)
	
	# If there's an existing tween, terminate it. Prevents multiple tweens running at the same time.
	if sprite_node_position_tween:
		sprite_node_position_tween.kill()
	sprite_node_position_tween = create_tween()
	sprite_node_position_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS) # Sets Tween to update in sync with the physics frame step
	sprite_node_position_tween.tween_property(self, "global_position", target_position, walk_speed).set_trans(Tween.TRANS_SINE)
	TurnManager.enemy_turn_end()

func _on_human_detect_area_body_entered(body: Human):
	humans_detected.append(body)

func _on_human_detect_area_body_exited(body: Human):
	humans_detected.erase(body)

func play_kill_audio() -> void:
	$WolfKillHumanSFX.play()
