# KeyObject.gd
extends StaticBody3D
class_name KeyObject

@export var key_id: String = "llave_generica"
@export var key_name: String = "Llave"
@export var pickup_sound: AudioStream
@export var interaction_key: String = "E"

signal key_collected(key_data)

func _ready():
	add_to_group("interactable")

func interact():
	print("Recogiendo llave: " + key_name)
	
	# Reproducir sonido de recogida
	#if pickup_sound:
		#var audio_player = AudioStreamPlayer3D.new()
		#add_child(audio_player)
		#audio_player.stream = pickup_sound
		#audio_player.play()
		#audio_player.finished.connect(func(): audio_player.queue_free())
	
	# Emitir señal con datos de la llave
	var key_data = {
		"id": key_id,
		"name": key_name,
		"sound": pickup_sound
	}
	key_collected.emit(key_data)

func get_interaction_text() -> String:
	return "Presiona " + interaction_key + " para recoger " + key_name

func highlight():
	print("Llave destacada: " + key_name)

func unhighlight():
	print("Llave no destacada: " + key_name)
