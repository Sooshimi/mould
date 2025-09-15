extends Node2D

@onready var infected_indicator := $InfectedIndicator

var top_infected := false
var bottom_infected := false
var left_infected := false
var right_infected := false
var cell_infected := false
var human_in_area := []

func checked_if_infected(body: CharacterBody2D) -> void:
	if top_infected and bottom_infected and left_infected and right_infected and human_in_area.size() > 0:
		infect_cell()
		for human in human_in_area:
			human.infected = true
			
	if human_in_area.size() > 0:
		for human in human_in_area:
			if human.infected:
				infect_cell()

func infect_cell() -> void:
	cell_infected = true
	infected_indicator.show()

func _on_top_body_entered(body: CharacterBody2D) -> void:
	if body is Slime:
		top_infected = true
	elif body is Human:
		human_in_area.append(body)
	checked_if_infected(body)

func _on_bottom_body_entered(body: CharacterBody2D) -> void:
	if body is Slime:
		bottom_infected = true
	elif body is Human:
		human_in_area.append(body)
	checked_if_infected(body)

func _on_left_body_entered(body: CharacterBody2D) -> void:
	if body is Slime:
		left_infected = true
	elif body is Human:
		human_in_area.append(body)
	checked_if_infected(body)

func _on_right_body_entered(body: CharacterBody2D) -> void:
	if body is Slime:
		right_infected = true
	elif body is Human:
		human_in_area.append(body)
	checked_if_infected(body)

func _on_top_body_exited(body: Human) -> void:
	human_in_area = []
