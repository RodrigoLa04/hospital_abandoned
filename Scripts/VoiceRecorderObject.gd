# VoiceRecorderObject.gd
extends StaticBody3D
class_name VoiceRecorderObject

@export var recorder_name: String = "Grabadora"
@export var voice_recording: AudioStream
@export var pickup_sound: AudioStream
@export var interaction_key: String = "E"

# Variables para eventos ambientales (como las notas)
@export var triggers_ambient_event: bool = false
@export var ambient_event_name: String = ""
@export var ambient_event_position: Vector3 = Vector3.ZERO

signal recorder_activated(recorder_data)

func _ready():
	add_to_group("interactable")

func interact():
	print("Activando grabadora: " + recorder_name)
	
	# Reproducir sonido de pickup si existe
	if pickup_sound:
		var audio_player = AudioStreamPlayer3D.new()
		add_child(audio_player)
		audio_player.stream = pickup_sound
		audio_player.play()
		audio_player.finished.connect(func(): audio_player.queue_free())
	
	# Emitir señal con datos de la grabadora
	var recorder_data = {
		"name": recorder_name,
		"recording": voice_recording,
		"key": interaction_key,
		"type": "recorder",
		"triggers_event": triggers_ambient_event,
		"event_name": ambient_event_name,
		"event_position": ambient_event_position
	}
	recorder_activated.emit(recorder_data)

func get_interaction_text() -> String:
	return "Presiona " + interaction_key + " para reproducir " + recorder_name

func highlight():
	print("Grabadora destacada: " + recorder_name)

func unhighlight():
	print("Grabadora no destacada: " + recorder_name)
