extends Area3D

@onready var audio_player = $AudioStreamPlayer3D

var already_triggered = false  # Para que solo suene una vez
var can_retrigger = false      # Si quieres que se pueda activar múltiples veces

func _ready():
	# Conectar la señal de entrada del área
	body_entered.connect(_on_body_entered)
	# Opcional: señal de salida
	#body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	# Verificar que sea el jugador
	if body.name == "Player" or body.is_in_group("player"):
		if not already_triggered or can_retrigger:
			play_audio()
			already_triggered = true

func _on_body_exited(body):
	# Opcional: detener audio al salir del área
	if body.name == "Player" or body.is_in_group("player"):
		if audio_player.playing:
			audio_player.stop()

func play_audio():
	if not audio_player.playing:
		audio_player.play()
		print("Reproduciendo audio trigger")
