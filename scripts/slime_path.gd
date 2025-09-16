extends Node2D

var point_list := []

func add_point(point: Vector2) -> void:
	point_list.append(point)
	queue_redraw()

func _draw() -> void:
	if point_list.size() > 0:
		draw_polyline(point_list, Color.LIME_GREEN, 6.0)
