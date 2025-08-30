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

#func highlight():
	#print("=== INICIANDO HIGHLIGHT ===")
	#var mesh_instance = find_mesh_instance(self)
	#if mesh_instance:
		#print("Encontrado MeshInstance3D: ", mesh_instance.name)
		#
		## Obtener o crear material
		#var material = mesh_instance.get_surface_override_material(0)
		#if not material:
			#material = StandardMaterial3D.new()
			#print("Creando nuevo material")
		#else:
			#material = material.duplicate()
			#print("Duplicando material existente")
		#
		## Aplicar efecto MÁS VISIBLE
		#if material is StandardMaterial3D:
			#material.emission = Color.YELLOW * 0.8  # Más intenso y amarillo
			#material.emission_enabled = true
			#material.rim_enabled = true
			#material.rim = Color.WHITE
			#material.rim_tint = 1.0
			#mesh_instance.set_surface_override_material(0, material)
			#print("Efecto aplicado - emisión amarilla y rim blanco")
	#else:
		#print("ERROR: No se encontró MeshInstance3D")
#
#func unhighlight():
	#var mesh_instance = find_mesh_instance(self)
	#if mesh_instance:
		#var material = mesh_instance.get_surface_override_material(0)
		#if material and material is StandardMaterial3D:
			#material.emission = Color.BLACK
			#material.emission_enabled = false
#
#func find_mesh_instance(node: Node) -> MeshInstance3D:
	## Buscar MeshInstance3D en este nodo y sus hijos
	#if node is MeshInstance3D:
		#return node
	#
	#for child in node.get_children():
		#var mesh = find_mesh_instance(child)
		#if mesh:
			#return mesh
	#
	#return null
