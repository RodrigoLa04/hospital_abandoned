extends Area3D

@onready var ui = get_tree().current_scene.get_node("Player/Player_ui")
@export var task_text: String
var triggered = false

func enter_trigger(body):
	if body.name == "Player" and !triggered:
		triggered = true
		ui.set_task(task_text)
		
