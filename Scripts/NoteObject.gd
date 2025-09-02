extends StaticBody3D
class_name NoteObject

@export var note_title: String = "Nota"
@export_multiline var note_content: String = "Contenido de la nota..."
@export var paper_sound: AudioStream
@export var interaction_key: String = "E"
@export var triggers_ambient_event: bool = false
@export var ambient_event_name: String = ""
@export var ambient_event_position: Vector3 = Vector3.ZERO

signal note_picked_up(note_data)

func _ready():
	add_to_group("interactable")

func interact():
	
	var note_data = {
		"title": note_title,
		"content": note_content,
		"key": interaction_key,
		"type": "note",
		"sound": paper_sound,  
		"triggers_event": triggers_ambient_event,
		"event_name": ambient_event_name,
		"event_position": ambient_event_position		
	}
	note_picked_up.emit(note_data)

func get_interaction_text() -> String:
	return "Presiona " + interaction_key + " para leer " + note_title

func highlight():
	print("Nota destacada: " + note_title)

func unhighlight():
	print("Nota no destacada: " + note_title)
