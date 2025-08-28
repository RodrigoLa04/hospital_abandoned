extends StaticBody3D
class_name NoteObject

@export var note_title: String = "Nota"
@export_multiline var note_content: String = "Contenido de la nota..."
@export var paper_sound: AudioStream
@export var interaction_key: String = "E"

signal note_picked_up(note_data)

func _ready():
	add_to_group("interactable")

func interact():
	print("Leyendo nota: " + note_title)
	
	# Reproducir sonido de papel
	#if paper_sound:
		#var audio_player = AudioStreamPlayer3D.new()
		#add_child(audio_player)
		#audio_player.stream = paper_sound
		#audio_player.play()
		## Eliminar el reproductor después de que termine
		#audio_player.finished.connect(func(): audio_player.queue_free())
	
	# Emitir señal con los datos de la nota
	var note_data = {
		"title": note_title,
		"content": note_content,
		"key": interaction_key,
		"type": "note",
		"sound": paper_sound
	}
	note_picked_up.emit(note_data)

func get_interaction_text() -> String:
	return "Presiona " + interaction_key + " para leer " + note_title

func highlight():
	print("Nota destacada: " + note_title)

func unhighlight():
	print("Nota no destacada: " + note_title)
