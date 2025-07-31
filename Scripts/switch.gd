extends Node3D

@export var on = false
@export var on_mat: StandardMaterial3D
@export var off_mat: StandardMaterial3D
@export var light_ceeling: Node3D



func _ready() -> void:
	if !on:
		light_ceeling.get_node("light").material_override = off_mat
	if on:
		light_ceeling.get_node("light").material_override = on_mat
	light_ceeling.get_node("OmniLight3D").visible = on
		

func toggle_light():
	on = !on
	if on:
		light_ceeling.get_node("light").material_override = on_mat
	if !on:
		light_ceeling.get_node("light").material_override = off_mat
		
		
	light_ceeling.get_node("OmniLight3D").visible = on
