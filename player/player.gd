extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

@onready var raycast = $Head/RayCast3D 
@onready var interaction_ui = $InteractionUI  # Nueva línea
var current_interactable: InteractableObject = null
var game_paused = false

func _ready():
	add_to_group("player")

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
			var interactable = collider as InteractableObject
			
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

func interact_with_object():
	if current_interactable:
		# Pausar el juego
		game_paused = true
		get_tree().paused = true
		
		# Liberar el mouse para poder hacer clic
		#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		# Conectar señal si no está conectada
		if not current_interactable.object_interacted.is_connected(_on_object_interacted):
			current_interactable.object_interacted.connect(_on_object_interacted)
		
		# Interactuar
		current_interactable.interact()

func _on_object_interacted(object_data):
	# Mostrar UI de descripción
	interaction_ui.show_description(object_data)

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
