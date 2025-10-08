extends StaticBody3D
class_name InteractableObject

@export var object_name: String = "Objeto Misterioso"
@export_multiline var description: String = "Un objeto interesante que merece ser examinado..."
@export var interaction_key: String = "E"

# Nueva variable para el outline
@onready var outlineMesh: MeshInstance3D = null
var selected = false

signal object_interacted(object_data)

func _ready():
	add_to_group("interactable")
	
	# Buscar el mesh del outline (ajusta el nombre según tu jerarquía)
	outlineMesh = find_child("OutlineMesh")
	
	if outlineMesh:
		outlineMesh.visible = false
		print("Outline encontrado para: ", object_name)
	else:
		print("ADVERTENCIA: No se encontró OutlineMesh en ", object_name)
	
	# Conectar señal del player
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.interact_object.connect(_set_selected)

func _process(delta):
	if outlineMesh:
		outlineMesh.visible = selected

func _set_selected(object):
	selected = self == object

func interact():
	print("Interactuando con: " + object_name)
	
	var object_data = {
		"name": object_name,
		"description": description,
		"key": interaction_key
	}
	object_interacted.emit(object_data)

func get_interaction_text() -> String:
	return "Presiona " + interaction_key + " para examinar " + object_name
