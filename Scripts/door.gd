extends Node3D

var opened = false

func toggle_door():
	if $AnimationPlayer.current_animation == null:
		opened = !opened
		if !opened:
			$AnimationPlayer.play("close")
		if !opened:
			$AnimationPlayer.play("open")
	
