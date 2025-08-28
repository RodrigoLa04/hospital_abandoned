# DoorObject.gd
extends StaticBody3D
class_name DoorObject

enum DoorType {
	UNLOCKED,      # Se abre sin llave
	LOCKED,        # Requiere llave específica
	PERMANENTLY_LOCKED  # Nunca se puede abrir
}

@export var door_type: DoorType = DoorType.UNLOCKED
@export var required_key_id: String = ""  # ID de la llave necesaria
@export var locked_message: String = "Esta puerta está cerrada con llave"
@export var permanently_locked_message: String = "Esta puerta parece estar sellada permanentemente"
@export var interaction_key: String = "E"

@onready var animation_player = $AnimationPlayer
var opened = false

signal door_interacted(door_data)

func _ready():
	add_to_group("interactable")

func interact():
	var door_data = {
		"type": door_type,
		"required_key": required_key_id,
		"opened": opened,
		"locked_message": locked_message,
		"permanently_locked_message": permanently_locked_message
	}
	door_interacted.emit(door_data)

func get_interaction_text() -> String:
	if door_type == DoorType.PERMANENTLY_LOCKED:
		return "Presiona " + interaction_key + " para examinar puerta"
	elif door_type == DoorType.LOCKED:
		return "Presiona " + interaction_key + " para usar puerta"
	else:
		return "Presiona " + interaction_key + " para " + ("cerrar" if opened else "abrir") + " puerta"

func toggle_door():
	if animation_player.current_animation != "open":
		opened = !opened
		if !opened:
			animation_player.play_backwards("open")
		if opened:
			animation_player.play("open")

func highlight():
	print("Puerta destacada")

func unhighlight():
	print("Puerta no destacada")
