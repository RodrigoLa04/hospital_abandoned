extends Node3D

var sensitivity = 0.2 
@export var flashlight_on_sound: AudioStream
@export var flashlight_off_sound: AudioStream
@onready var audio_player = AudioStreamPlayer3D.new()

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	add_child(audio_player)  # Agregar reproductor de audio
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		$flashlight.visible = !$flashlight.visible
		
		# Reproducir sonido según el estado
		if $flashlight.visible:
			# Linterna encendida
			if flashlight_on_sound:
				audio_player.stream = flashlight_on_sound
				audio_player.play()
		else:
			# Linterna apagada
			if flashlight_off_sound:
				audio_player.stream = flashlight_off_sound
				audio_player.play()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: 
		get_parent().rotate_y(deg_to_rad(-event.relative.x * sensitivity))
		rotate_x(deg_to_rad(-event.relative.y * sensitivity))
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
