extends Node2D

var point_list := []
@export var LINE_WIDTH: int = 3

func add_point(point: Vector2) -> void:
	point_list.append(point)
	queue_redraw()

func _draw() -> void:
	if point_list.size() > 0:
		draw_polyline(point_list, Color("#d3e07F"), LINE_WIDTH)
