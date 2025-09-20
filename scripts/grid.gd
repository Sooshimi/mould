extends Node2D

@export var cell_scene: PackedScene

const CELL_SIZE := 32
const GRID_SIZE := 16

func _ready() -> void:
	create_grid()

func create_grid() -> void:
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var cell = cell_scene.instantiate()
			add_child(cell)
			
			# Place each cell so its center is correctly aligned
			var pos_x = x * CELL_SIZE + CELL_SIZE / 2
			var pos_y = y * CELL_SIZE + CELL_SIZE / 2
			cell.position = Vector2(pos_x, pos_y)
