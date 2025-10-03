extends RayCast3D
@onready var crosshair = get_parent().get_parent().get_node("Player_ui/CanvasLayer/crosshair")

# Variable para trackear el objeto actual con outline
var current_highlighted_object = null

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _physics_process(delta: float) -> void:
	var new_highlighted_object = null
	
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
		elif hit.name == "drawer":
			if !crosshair.visible:
				crosshair.visible = true
			if Input.is_action_just_pressed("interact"):
				hit.get_parent().get_parent().toggle_door()
		elif hit.is_in_group("interactable"):
			if !crosshair.visible:
				crosshair.visible = true
			# Marcar este objeto para highlight
			new_highlighted_object = hit
		else: 
			if crosshair.visible:
				crosshair.visible = false
	else: 
		if crosshair.visible:
			crosshair.visible = false
	
