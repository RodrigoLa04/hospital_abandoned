extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

@onready var raycast = $Head/RayCast3D 
@onready var interaction_ui = $InteractionUI  # Nueva línea
var current_interactable = null
var game_paused = false
@onready var inventory = Inventory.new()

func _ready():
	add_to_group("player")
	add_child(inventory)
	

func _input(event):
	# Detectar tecla de interacción
	if event.is_action_pressed("interact") and current_interactable and not game_paused:
		interact_with_object()

func _physics_process(delta: float) -> void:
	if not game_paused:
		handle_movement(delta)
		check_for_interactables()
	else:
		print("No se mueve porque game_paused es: ", game_paused)

func handle_movement(delta: float) -> void:
	# Tu código de movimiento existente (sin cambios)
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# Handle jump 
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()



func check_for_interactables():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		
		# Verificar si es un objeto interactuable
		if collider and collider.is_in_group("interactable"):
			var interactable = collider
			
			# Si es un objeto diferente al actual
			if current_interactable != interactable:
				# Quitar highlight del objeto anterior
				if current_interactable:
					current_interactable.unhighlight()
				
				# Establecer nuevo objeto
				current_interactable = interactable
				current_interactable.highlight()
				
				# Mostrar en consola por ahora (después haremos la UI)
				interaction_ui.show_prompt(current_interactable.get_interaction_text())
		else:
			# No hay objeto interactuable
			clear_current_interactable()
	else:
		# Raycast no está tocando nada
		clear_current_interactable()

func clear_current_interactable():
	if current_interactable:
		current_interactable.unhighlight()
		current_interactable = null
		interaction_ui.hide_prompt()
		
func _on_key_collected(key_data):
	inventory.add_item(key_data.id)
	# Eliminar la llave del mundo
	current_interactable.queue_free()
	clear_current_interactable()

func interact_with_object():
	if current_interactable:
		# Pausar el juego solo para objetos que lo requieren
		var needs_pause = true
		
		# Las puertas no necesitan pausar el juego
		if current_interactable.get_script() and current_interactable.get_script().get_global_name() == "DoorObject":
			needs_pause = false
		elif current_interactable.get_script() and current_interactable.get_script().get_global_name() == "KeyObject":
			needs_pause = false
		
		if needs_pause:
			game_paused = true
			get_tree().paused = true
		
		# Conectar señales según el tipo de objeto
		if current_interactable.get_script() and current_interactable.get_script().get_global_name() == "NoteObject":
			if not current_interactable.note_picked_up.is_connected(_on_note_picked_up):
				current_interactable.note_picked_up.connect(_on_note_picked_up)
		elif current_interactable.get_script() and current_interactable.get_script().get_global_name() == "DoorObject":
			if not current_interactable.door_interacted.is_connected(_on_door_interacted):
				current_interactable.door_interacted.connect(_on_door_interacted)
		# En interact_with_object(), agrega esta condición:
		elif current_interactable.get_script() and current_interactable.get_script().get_global_name() == "KeyObject":
			if not current_interactable.key_collected.is_connected(_on_key_collected):
				current_interactable.key_collected.connect(_on_key_collected)
		else:
			if not current_interactable.object_interacted.is_connected(_on_object_interacted):
				current_interactable.object_interacted.connect(_on_object_interacted)
		
		# Interactuar
		current_interactable.interact()

func _on_object_interacted(object_data):
	# Mostrar UI de descripción
	interaction_ui.show_description(object_data)
	
func _on_note_picked_up(note_data):
	# Mostrar UI de nota
	interaction_ui.show_note(note_data)

# Función temporal para reanudar con ESC
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and game_paused:
		resume_game()

func resume_game():
	print("=== INTENTANDO REANUDAR ===")
	game_paused = false
	print("game_paused ahora es: ", game_paused)
	get_tree().paused = false
	print("get_tree().paused ahora es: ", get_tree().paused)
	clear_current_interactable()
	print("Juego reanudado")
	
func _on_door_interacted(door_data):
	# Manejar diferentes tipos de puertas
	if door_data.type == 2:  # PERMANENTLY_LOCKED
		print("Mensaje: " + door_data.permanently_locked_message)
		# Mostrar mensaje temporal (podrías usar la UI aquí)
	elif door_data.type == 1:  # LOCKED
		# Verificar si el jugador tiene la llave
		if inventory.has_item(door_data.required_key):
			print("Usaste la llave: " + door_data.required_key)
			current_interactable.toggle_door()
			print("Puerta " + ("cerrada" if door_data.opened else "abierta") + " con llave")
		else:
			print("Mensaje: " + door_data.locked_message)
			print("Necesitas: " + door_data.required_key)
	else:  # UNLOCKED
		current_interactable.toggle_door()
		print("Puerta " + ("cerrada" if door_data.opened else "abierta"))
	
