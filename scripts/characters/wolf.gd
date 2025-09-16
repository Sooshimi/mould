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

func _on_human_detect_area_body_entered(body: Human):
	humans_detected.append(body)

func _on_human_detect_area_body_exited(body: Human):
	humans_detected.erase(body)
