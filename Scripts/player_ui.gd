extends Control



func _ready() -> void:
	$pause_menu.visible = false
	set_task("apaga la luz")
	
func resume_game():
	get_tree().paused = false
	$pause_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func quit_game():
	get_tree().quit()
	
func set_task(task_text: String):
	$task_ui/task_text.text = task_text
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		$pause_menu.visible = !$pause_menu.visible
		get_tree().paused = $pause_menu.visible
		if get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if !get_tree().paused:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		
