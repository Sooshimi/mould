extends Node2D

@export var cell_scene: PackedScene

const CELL_SIZE := 32
@export var GRID_SIZE := 16
const BORDER_THICKNESS := 3
const BORDER_COLOUR := Color("b6d53c80")

func _ready() -> void:
	create_grid()
	queue_redraw()

func create_grid() -> void:
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell = cell_scene.instantiate()
			add_child(cell)
			
			var pos_x = x * CELL_SIZE + CELL_SIZE / 2
			var pos_y = y * CELL_SIZE + CELL_SIZE / 2
			cell.position = Vector2(pos_x, pos_y)

func _draw() -> void:
	var total_width = GRID_SIZE * CELL_SIZE
	var total_height = GRID_SIZE * CELL_SIZE

	for x in range(GRID_SIZE + 1):
		var x_pos = x * CELL_SIZE
		draw_line(
			Vector2(x_pos, 0),
			Vector2(x_pos, total_height),
			BORDER_COLOUR,
			BORDER_THICKNESS
		)

	for y in range(GRID_SIZE + 1):
		var y_pos = y * CELL_SIZE
		draw_line(
			Vector2(0, y_pos),
			Vector2(total_width, y_pos),
			BORDER_COLOUR,
			BORDER_THICKNESS
		)
