extends Node2D

func _ready() -> void:
	%Player_Fire.level_up.connect(level_up_screen)

func pause():
	get_tree().paused = true
	$Pause_Menu.show()
	
func unpause():
	$Pause_Menu.hide()
	get_tree().paused = false
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		pause()
	


func _on_resume_button_pressed() -> void:
	unpause()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func level_up_screen():
	get_tree().paused = true
