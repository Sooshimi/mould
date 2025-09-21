extends AI
class_name Wolf

var humans_detected := []
var human_to_chase: Human
var slime_passed_top := false
var slime_passed_bottom := false
var slime_passed_left := false
var slime_passed_right := false

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
	
	slime_passed_top = false
	slime_passed_bottom = false
	slime_passed_left = false
	slime_passed_right = false
	
	TurnManager.enemy_turn_end()

func _on_human_detect_area_body_entered(body: Human):
	humans_detected.append(body)

func _on_human_detect_area_body_exited(body: Human):
	humans_detected.erase(body)

func play_kill_audio() -> void:
	$WolfKillHumanSFX.play()

func check_killed_by_slime() -> void:
	if slime_passed_top and slime_passed_bottom and slime_passed_left and slime_passed_right:
		queue_free()
		TurnManager.wolf_die.emit()

func _on_up_area_body_entered(_body: Slime) -> void:
	slime_passed_top = true
	check_killed_by_slime()

func _on_down_area_body_entered(_body: Slime) -> void:
	slime_passed_bottom = true
	check_killed_by_slime()

func _on_left_area_body_entered(_body: Slime) -> void:
	slime_passed_left = true
	check_killed_by_slime()

func _on_right_area_body_entered(_body: Slime) -> void:
	slime_passed_right = true
	check_killed_by_slime()
