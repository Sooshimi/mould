extends AI
class_name Human

var caught_by_wolf := false
var die_next_turn := false

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

func _on_wolf_detect_area_body_entered(_body: Wolf) -> void:
	caught_by_wolf = true

func _on_killed_area_body_entered(_body: Wolf):
	queue_free()
