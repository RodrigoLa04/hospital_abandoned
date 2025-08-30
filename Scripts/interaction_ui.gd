extends Control

@onready var prompt_label = $PromptLabel
@onready var description_panel = $DescriptionPanel
@onready var description_text = $DescriptionPanel/DescriptionText


@onready var note_panel = $NotePanel
@onready var note_title_label = $NotePanel/NoteTitleLabel
@onready var note_content_text = $NotePanel/NoteContentText
@onready var note_instruction_label = $NotePanel/NoteInstructionLabel


# NUEVAS LÍNEAS PARA INVENTARIO:
@onready var inventory_ui = $InventoryUI
@onready var inventory_panel = $InventoryUI/InventoryPanel
@onready var inventory_title = $InventoryUI/InventoryPanel/InventoryTitle
@onready var item_list = $InventoryUI/InventoryPanel/ItemList

@onready var message_label = Label.new()



var player: CharacterBody3D

func _ready():
	prompt_label.visible = false
	description_panel.visible = false
	note_panel.visible = false 
	inventory_ui.visible = true 
	
	setup_message_system()
	
	player = get_parent()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	
	message_label.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func show_prompt(text: String):
	prompt_label.text = text
	prompt_label.visible = true

func hide_prompt():
	prompt_label.visible = false

func show_description(object_data: Dictionary):

	description_text.text = object_data.description
	hide_prompt()
	description_panel.visible = true

func _on_close_button_pressed():
	print("=== CERRANDO VENTANA ===")
	description_panel.visible = false
	if player:
		player.resume_game()
	else:
		print("ERROR: No se encontró el player")
		
func _input(event):
	if event.is_action_pressed("interact"):
		# Cerrar descripción normal
		if description_panel.visible:
			print("=== PRESIONASTE E PARA CERRAR DESCRIPCIÓN ===")
			_on_close_button_pressed()
		# Cerrar nota
		elif note_panel.visible:
			print("=== PRESIONASTE E PARA CERRAR NOTA ===")
			hide_note()
# NUEVAS FUNCIONES PARA NOTAS
func show_note(note_data: Dictionary):
	print("=== MOSTRANDO NOTA ===")
	print("Datos recibidos: ", note_data)
	note_title_label.text = note_data.title
	note_content_text.text = note_data.content
	
	if note_data.has("sound") and note_data.sound:
		print("Reproduciendo sonido: ", note_data.sound)
		var audio_player = AudioStreamPlayer.new()
		add_child(audio_player)
		audio_player.stream = note_data.sound
		audio_player.play()
		audio_player.finished.connect(func(): audio_player.queue_free())
	else:
		print("No hay sonido o sonido es null")
		
	var crosshair = get_node("../Player_ui/CanvasLayer/crosshair")  # Ajusta la ruta si es necesaria
	if crosshair:
		crosshair.visible = false
	
	# Ocultar prompt y mostrar nota
	
	hide_prompt()
	note_panel.visible = true

func hide_note():
	note_panel.visible = false
	
	var crosshair = get_node("../Player_ui/CanvasLayer/crosshair")
	if crosshair:
		crosshair.visible = true
	# Reanudar el juego
	if player:
		player.resume_game()
		
		
# FUNCIONES PARA INVENTARIO
func update_inventory_display(items: Array[String]):
	# Limpiar la lista actual
	for child in item_list.get_children():
		child.queue_free()
	
	# Agregar cada item como Label
	for item_id in items:
		var item_label = Label.new()
		item_label.text = "- " + item_id.replace("_", " ").capitalize()
		item_list.add_child(item_label)

func add_item_to_display(item_id: String):
	var item_label = Label.new()
	item_label.text = "- " + item_id.replace("_", " ").capitalize()
	item_list.add_child(item_label)


func setup_message_system():
	
	# Configurar label de mensaje
	add_child(message_label)
	message_label.visible = false
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Posicionamiento simple y directo
	message_label.position = Vector2(375, 375)  # Coordenadas fijas para probar
	message_label.size = Vector2(400, 50)       # Tamaño fijo
	



	
	# AGREGAR CONFIGURACIÓN DE FUENTE:
	# Opción 1: Cargar fuente desde archivo
	var font = load("res://Assets/reactor7/Reactor7.ttf")  # Cambia por tu ruta
	if font:
		message_label.add_theme_font_override("font", font)
		message_label.add_theme_font_size_override("font_size", 24)  # Tamaño
	
	# Opción 2: Cambiar solo el tamaño (si quieres mantener la fuente por defecto)
	# message_label.add_theme_font_size_override("font_size", 28)
	
	# Opción 3: Cambiar color
	# message_label.add_theme_color_override("font_color", Color.WHITE)

func show_message(text: String, duration: float = 3.0):
	message_label.text = text
	message_label.visible = true
	
	# Usar get_tree().create_timer en lugar del timer nodo
	get_tree().create_timer(duration).timeout.connect(_on_message_timeout)

func _on_message_timeout():
	message_label.visible = false
	
	
