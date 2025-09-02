# AmbientEventManager.gd
extends Node3D
class_name AmbientEventManager

# Configurar diferentes sonidos ambientales
@export var phone_sound: AudioStream
@export var door_creak_sound: AudioStream
@export var footsteps_above_sound: AudioStream
@export var whisper_sound: AudioStream
@export var glass_break_sound: AudioStream

# Reproductores para diferentes tipos de audio
@onready var distant_player = AudioStreamPlayer3D.new()  # Para sonidos lejanos
@onready var nearby_player = AudioStreamPlayer3D.new()   # Para sonidos cercanos

var events_triggered = {}

func _ready():
	# Configurar reproductores
	add_child(distant_player)
	add_child(nearby_player)
	
	# Configuración para sonidos lejanos (teléfono, pasos arriba)
	distant_player.max_distance = 150.0
	distant_player.unit_size = 20.0
	
	# Configuración para sonidos cercanos (crujidos, susurros)
	nearby_player.max_distance = 50.0
	nearby_player.unit_size = 5.0

func trigger_event(event_name: String, position: Vector3 = Vector3.ZERO):
	var event_key = event_name
	
	# Algunos eventos pueden repetirse, otros no
	var can_repeat = event_name in ["door_creak", "glass_break"]
	
	if events_triggered.get(event_key, false) and not can_repeat:
		return
	
	match event_name:
		"phone_ring":
			if phone_sound:
				distant_player.global_position = position if position != Vector3.ZERO else global_position
				distant_player.stream = phone_sound
				distant_player.play()
				events_triggered[event_key] = true
				print("Teléfono sonando en la distancia...")
		
		"door_creak":
			if door_creak_sound:
				nearby_player.global_position = position
				nearby_player.stream = door_creak_sound
				nearby_player.play()
				print("Sonido de puerta crujiendo...")
		
		"footsteps_above":
			if footsteps_above_sound:
				distant_player.global_position = position
				distant_player.stream = footsteps_above_sound
				distant_player.play()
				print("Pasos en el piso de arriba...")
