extends Node2D

@onready var infected_indicator := $InfectedIndicator

var top_infected := false
var bottom_infected := false
var left_infected := false
var right_infected := false
var cell_infected := false

func is_infected() -> void:
	if top_infected and bottom_infected and left_infected and right_infected:
		cell_infected = true
		infected_indicator.show()

func _on_top_body_entered(body: CharacterBody2D) -> void:
	top_infected = true
	is_infected()

func _on_bottom_body_entered(body: CharacterBody2D) -> void:
	bottom_infected = true
	is_infected()

func _on_left_body_entered(body: CharacterBody2D) -> void:
	left_infected = true
	is_infected()

func _on_right_body_entered(body: CharacterBody2D) -> void:
	right_infected = true
	is_infected()
