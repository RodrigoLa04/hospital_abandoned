extends Control

@onready var intro_text = $IntroText
@onready var color_rect = $ColorRect
@export var intro_duration: float = 8.0
@export var fade_duration: float = 1.0
@export_multiline var intro_message: String = "En un hospital abandonado...\n\nLa oscuridad envuelve cada rincón.\n\nSolo tu linterna te guía."

var can_skip = false

func _ready():
	# Configurar el texto inicialmente invisible
	intro_text.text = intro_message
	intro_text.modulate.a = 0.0
	
	# Iniciar secuencia de fade in
	start_intro_sequence()
	
	set_process_input(true)

func start_intro_sequence():
	# Fade in del texto
	var tween = create_tween()
	tween.tween_property(intro_text, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(func(): can_skip = true)
	
	# Crear timer para el fade out
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = intro_duration - fade_duration
	timer.one_shot = true
	timer.timeout.connect(start_fade_out)
	timer.start()

func start_fade_out():
	var tween = create_tween()
	tween.tween_property(intro_text, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(_on_intro_finished)

func _input(event):
	# Solo permitir saltar después del fade in inicial
	if event.is_pressed() and can_skip:
		# Fade out rápido
		var tween = create_tween()
		tween.tween_property(intro_text, "modulate:a", 0.0, 0.5)
		tween.tween_callback(_on_intro_finished)

func _on_intro_finished():
	# Fade out de toda la pantalla antes de cambiar escena
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(change_to_main_scene)

func change_to_main_scene():
	get_tree().change_scene_to_file("res://recepcion.tscn")
