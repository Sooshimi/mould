extends Node2D

@export var cell_scene: PackedScene

const CELL_SIZE := 32
const BORDER_THICKNESS := 3
const GRID_SIZE := 16

func _ready() -> void:
	create_grid()

func create_grid() -> void:
	for y in range (GRID_SIZE):
		for x in range (GRID_SIZE):
			var cell = cell_scene.instantiate()
			add_child(cell)
			
			# Calculate position with borders
			var pos_x = BORDER_THICKNESS + x * (CELL_SIZE + BORDER_THICKNESS)
			var pos_y = BORDER_THICKNESS + y * (CELL_SIZE + BORDER_THICKNESS)
			cell.position = Vector2(pos_x, pos_y)
