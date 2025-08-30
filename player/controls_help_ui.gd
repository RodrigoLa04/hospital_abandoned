extends Control

@export var display_duration: float = 8.0
@export var fade_duration: float = 2.0

func _ready():
	visible = true
	modulate.a = 1.0
	
	# Crear timer para iniciar fade out
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = display_duration
	timer.one_shot = true
	timer.timeout.connect(start_fade_out)
	timer.start()

func start_fade_out():
	# Fade out gradual
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(hide_controls)

func hide_controls():
	visible = false
