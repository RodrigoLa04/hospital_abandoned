extends RayCast3D
@onready var crosshair = get_parent().get_parent().get_node("Player_ui/CanvasLayer/crosshair")

func _physics_process(delta: float) -> void:
	if is_colliding():
		var hit = get_collider()
		if hit.name == "light_switch":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().toggle_light()
		elif hit.name == "door":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().get_parent().toggle_door()
		elif hit.name == "drawer":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().toggle_door()
		elif hit.is_in_group("interactable"):  # ← NUEVA LÍNEA
			if !crosshair.visible:
				crosshair.visible = true
			# No manejamos el input aquí, eso lo hace el Player
		else: 
			if crosshair.visible:
				crosshair.visible = false
	else: 
		if crosshair.visible:
			crosshair.visible = false
