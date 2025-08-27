extends Control

@onready var prompt_label = $PromptLabel
@onready var description_panel = $DescriptionPanel

@onready var description_text = $DescriptionPanel/DescriptionText


var player: CharacterBody3D

func _ready():
	prompt_label.visible = false
	description_panel.visible = false
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
	if event.is_action_pressed("interact") and description_panel.visible:
		print("=== PRESIONASTE E PARA CERRAR ===")
		_on_close_button_pressed()
