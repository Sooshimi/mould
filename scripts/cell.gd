extends Node2D

var top_infected := false
var bottom_infected := false
var left_infected := false
var right_infected := false
var cell_infected := false
var human_in_area := []

func checked_if_infected(_body: CharacterBody2D) -> void:
	if top_infected and bottom_infected and left_infected and right_infected:
		infect_cell()
	
	# If a human walks into the INFECTED CELL, infect the human
	if cell_infected:
		if human_in_area.size() > 0:
			for human in human_in_area:
				if is_instance_valid(human):
					human.infected = true
	
	# If an INFECTED HUMAN walks into the cell, infect the cell
	if human_in_area.size() > 0:
		for human in human_in_area:
			if is_instance_valid(human):
				if human.infected:
					infect_cell()

func infect_cell() -> void:
	if not cell_infected:
		cell_infected = true
		TurnManager.increment_infected_cells()
		$InfectedIndicator.show()

func update_cell_status(cell_area_entered: String, body: CharacterBody2D) -> void:
	if body is Slime:
		if cell_area_entered == "top":
			if not top_infected:
				top_infected = true
		elif cell_area_entered == "bottom":
			if not bottom_infected:
				bottom_infected = true
		elif cell_area_entered == "left":
			if not left_infected:
				left_infected = true
		else:
			if not right_infected:
				right_infected = true
				
	checked_if_infected(body)

func _on_top_body_entered(body: CharacterBody2D) -> void:
	if body is Human:
		human_in_area.append(body)
	update_cell_status("top", body)

func _on_bottom_body_entered(body: CharacterBody2D) -> void:
	update_cell_status("bottom", body)

func _on_left_body_entered(body: CharacterBody2D) -> void:
	update_cell_status("left", body)

func _on_right_body_entered(body: CharacterBody2D) -> void:
	update_cell_status("right", body)

func _on_top_body_exited(body: CharacterBody2D) -> void:
	if body is Human:
		human_in_area = []
