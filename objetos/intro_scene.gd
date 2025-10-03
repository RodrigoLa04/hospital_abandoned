extends Control
@onready var intro_text = $IntroText
@onready var color_rect = $ColorRect
@export var fade_duration: float = 1.0
@export var typing_speed: float = 0.05  # Velocidad de escritura (segundos entre caracteres)

# Ahora definimos los mensajes del chat desde el inspector
@export var message_1: String = "???: ¿Hay alguien ahí?"
@export var message_2: String = "Tú: Sí... ¿quién eres?"
@export var continue_prompt: String = "\n\n[Presiona E para continuar]"

var can_skip = false
var is_typing = false
var chat_finished = false
var can_continue = false

func _ready():
	# Configurar el texto inicialmente invisible y vacío
	intro_text.text = ""
	intro_text.modulate.a = 0.0
	
	# Iniciar secuencia de chat
	start_chat_sequence()
	
	set_process_input(true)

func start_chat_sequence():
	# Fade in del área de texto
	var tween = create_tween()
	tween.tween_property(intro_text, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(start_typing_messages)

func start_typing_messages():
	can_skip = true
	is_typing = true
	
	# Escribir primer mensaje
	await type_message(message_1)
	
	# Pausa entre mensajes
	await get_tree().create_timer(1.0).timeout
	
	# Escribir segundo mensaje
	await type_message(message_2)
	
	is_typing = false
	chat_finished = true
	
	# Pausa antes de mostrar el prompt para continuar
	await get_tree().create_timer(1.0).timeout
	
	show_continue_prompt()

func type_message(message: String):
	# Agregar el mensaje línea por línea, carácter por carácter
	var current_text = intro_text.text
	if current_text != "":
		current_text += "\n\n"  # Separar mensajes
	
	# Escribir cada carácter con delay
	for i in range(message.length()):
		if not is_typing:  # Si se saltó, escribir todo de una vez
			intro_text.text = current_text + message
			return
			
		intro_text.text = current_text + message.substr(0, i + 1)
		await get_tree().create_timer(typing_speed).timeout

func show_continue_prompt():
	# Añadir el prompt para continuar con efecto de escritura
	var current_text = intro_text.text
	
	# Escribir el prompt de continuar
	for i in range(continue_prompt.length()):
		intro_text.text = current_text + continue_prompt.substr(0, i + 1)
		await get_tree().create_timer(typing_speed).timeout
	
	can_continue = true

func start_fade_out():
	var tween = create_tween()
	tween.tween_property(intro_text, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(_on_intro_finished)

func _input(event):
	# Control durante el chat
	if can_skip and not chat_finished:
		if event.is_pressed():
			if is_typing:
				# Si está escribiendo, completar el texto inmediatamente
				is_typing = false
			else:
				# Si ya terminó de escribir, saltar directamente al final
				var tween = create_tween()
				tween.tween_property(intro_text, "modulate:a", 0.0, 0.5)
				tween.tween_callback(_on_intro_finished)
	
	# Control para continuar después del chat
	elif can_continue:
		if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.keycode == KEY_E and event.pressed):
			can_continue = false
			start_fade_out()

func _on_intro_finished():
	# Fade out de toda la pantalla antes de cambiar escena
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(change_to_main_scene)

func change_to_main_scene():
	get_tree().change_scene_to_file("res://recepcion.tscn")
