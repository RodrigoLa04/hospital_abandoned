extends Control

@onready var prompt_label = $PromptLabel
@onready var description_panel = $DescriptionPanel
@onready var description_text = $DescriptionPanel/DescriptionText


@onready var note_panel = $NotePanel
@onready var note_title_label = $NotePanel/NoteTitleLabel
@onready var note_content_text = $NotePanel/NoteContentText
@onready var note_instruction_label = $NotePanel/NoteInstructionLabel


var player: CharacterBody3D

func _ready():
	prompt_label.visible = false
	description_panel.visible = false
	note_panel.visible = false 
	
	player = get_parent()
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

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
	
	# Ocultar prompt y mostrar nota
	hide_prompt()
	note_panel.visible = true

func hide_note():
	note_panel.visible = false
	# Reanudar el juego
	if player:
		player.resume_game()
