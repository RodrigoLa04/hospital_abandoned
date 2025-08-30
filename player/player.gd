extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

@onready var raycast = $Head/RayCast3D 
@onready var interaction_ui = $InteractionUI  # Nueva línea
var current_interactable = null
var game_paused = false
@onready var inventory = Inventory.new()

@export var footstep_sounds: Array[AudioStream] = []
@export var footstep_interval: float = 0.6  # Tiempo entre pasos
@onready var footstep_player = AudioStreamPlayer3D.new()

var footstep_timer: float = 0.0
var is_moving = false

func _ready():
	add_to_group("player")
	add_child(inventory)
	
	add_child(footstep_player)
	footstep_player.max_distance = 20.0  
		
	inventory.item_added.connect(_on_item_added_to_inventory)
	inventory.item_removed.connect(_on_item_removed_from_inventory)
	

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
	
	var actually_moving = input_dir.length() > 0.1  # Detectar input real
	print("input_dir: ", input_dir, " actually_moving: ", actually_moving)
	handle_footsteps(delta, actually_moving and is_on_floor())



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
				#current_interactable.highlight()
				
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
		#current_interactable.unhighlight()
		current_interactable = null
		interaction_ui.hide_prompt()


		
func _on_key_collected(key_data):
	inventory.add_item(key_data.id)
	interaction_ui.show_message("Recogiste: " + key_data.name)
	# Reproducir sonido si existe
	#if key_data.has("sound") and key_data.sound:
		#interaction_ui.play_pickup_sound(key_data.sound)
	
	# Eliminar la llave del mundo
	current_interactable.queue_free()
	clear_current_interactable()

func interact_with_object():
	if current_interactable:
		print("=== INTERACTUANDO ===")
		print("Tipo de objeto: ", current_interactable.get_script().get_global_name() if current_interactable.get_script() else "Sin script")
		
		var needs_pause = true
		
		# Las puertas no necesitan pausar el juego
		if current_interactable.get_script() and current_interactable.get_script().get_global_name() == "DoorObject":
			needs_pause = false
			print("Es puerta - no pausar")
		elif current_interactable.get_script() and current_interactable.get_script().get_global_name() == "KeyObject":
			needs_pause = false
			print("Es llave - no pausar")
		else:
			print("Es otro objeto - sí pausar")
		
		print("needs_pause = ", needs_pause)
		
		if needs_pause:
			print("PAUSANDO JUEGO")
			game_paused = true
			get_tree().paused = true
			print("get_tree().paused = ", get_tree().paused)
		
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
		current_interactable.play_locked_sound()  # NUEVA LÍNEA
		interaction_ui.show_message(door_data.permanently_locked_message)
	elif door_data.type == 1:  # LOCKED
		# Verificar si el jugador tiene la llave
		if inventory.has_item(door_data.required_key):
			interaction_ui.show_message("Usaste: " + door_data.required_key.replace("_", " ").capitalize())
			current_interactable.toggle_door()
		else:
			current_interactable.play_locked_sound()  # NUEVA LÍNEA
			interaction_ui.show_message(door_data.locked_message)
	else:  # UNLOCKED
		current_interactable.toggle_door()
		var action = "abierta" if not door_data.opened else "cerrada"
		interaction_ui.show_message("Puerta " + action)
		
func _on_item_added_to_inventory(item_id: String):
	interaction_ui.add_item_to_display(item_id)

func _on_item_removed_from_inventory(item_id: String):
	# Actualizar toda la display cuando se remueve un item
	interaction_ui.update_inventory_display(inventory.get_all_items())
	
func handle_footsteps(delta: float, is_moving: bool):
	if is_moving:
		footstep_timer += delta
		
		if footstep_timer >= footstep_interval:
			play_footstep()
			footstep_timer = 0.0
	else:
		footstep_timer = 0.0
		if footstep_player.playing:
			footstep_player.stop()

func play_footstep():
	print("Sonidos disponibles: ", footstep_sounds.size())
	if footstep_sounds.size() > 0:
		var random_sound = footstep_sounds[randi() % footstep_sounds.size()]
		print("Reproduciendo sonido: ", random_sound)
		footstep_player.stream = random_sound
		footstep_player.play()
		print("Audio player playing: ", footstep_player.playing)
	else:
		print("No hay sonidos de pasos configurados")
