extends StaticBody3D
class_name InteractableObject

@export var object_name: String = "Objeto Misterioso"
@export_multiline var description: String = "Un objeto interesante que merece ser examinado..."
@export var interaction_key: String = "E"

signal object_interacted(object_data)

func _ready():
	# Agregar al grupo de interactuables
	add_to_group("interactable")

func interact():
	print("Interactuando con: " + object_name)
	
	# Emitir señal con los datos del objeto
	var object_data = {
		"name": object_name,
		"description": description,
		"key": interaction_key
	}
	object_interacted.emit(object_data)

func get_interaction_text() -> String:
	return "Presiona " + interaction_key + " para examinar " + object_name

# Opcional: destacar el objeto cuando se mira
func highlight():
	# Aquí puedes agregar efectos visuales
	print("Objeto destacado: " + object_name)

func unhighlight():
	# Quitar efectos visuales
	print("Objeto no destacado: " + object_name)
