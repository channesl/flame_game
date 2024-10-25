extends Node2D

func _ready() -> void:
	%Player_Fire.level_up.connect(level_up_screen)
	$Level_Up_Screen/Level_Up_Menu.perk_chosen.connect(extra_perk_chosen)

func pause():
	get_tree().paused = true
	$Pause_Menu.show()
	Input.set_custom_mouse_cursor(null)
	
func _physics_process(delta: float) -> void:
	forest_audio_handler()
	
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
	$Level_Up_Screen/Level_Up_Menu.init_level_up()
	$Level_Up_Screen.show()
	Input.set_custom_mouse_cursor(null)
	
func extra_perk_chosen():
	$Level_Up_Screen.hide()
	get_tree().paused = false

func forest_audio_handler():
	if $Boss_Room.boss_room_active:
		$Audio/AudioStreamPlayer_Forest_Ambiance.stream_paused = true
		$Audio/AudioStreamPlayer_Boss_Music.stream_paused = false
		$Audio/AudioStreamPlayer_Main_Music.stream_paused = true
	else:
		$Audio/AudioStreamPlayer_Boss_Music.stream_paused = true
