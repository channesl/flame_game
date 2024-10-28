extends Node2D

@onready var hit_audio = preload("res://scenes/audio/audio_stream_player_hit.tscn")
@onready var audio_group = get_node("Audio")
@onready var collision_particles = preload("res://scenes/particles/fire_collision_particles.tscn")
@onready var particles_group = get_node("Particles")

func _ready() -> void:
	%Player_Fire.level_up.connect(level_up_screen)
	%Player_Fire.died.connect(game_over_animation)
	%Player_Fire.game_won.connect(game_won_screen)
	$Level_Up_Screen/Level_Up_Menu.perk_chosen.connect(extra_perk_chosen)
	$Transition/Blackscreen_Transition.game_start()

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

func game_over_animation():
	
	var tween = get_tree().create_tween()
	tween.tween_callback(death_sound_particle)
	tween.tween_interval(1.5)
	tween.tween_callback($Game_Over/Game_Over_Screen.show)
	tween.tween_callback(game_over_screen)

func death_sound_particle():
	%Player_Fire.hide()
	var new_hit_audio_scene = hit_audio.instantiate()
	audio_group.call_deferred("add_child", new_hit_audio_scene)
	new_hit_audio_scene.position = %Player_Fire.position
	new_hit_audio_scene.play()
	var new_particles_scene = collision_particles.instantiate()
	particles_group.call_deferred("add_child", new_particles_scene)
	new_particles_scene.position = %Player_Fire.position
	new_particles_scene.emitting = true

func game_over_screen():
	Input.set_custom_mouse_cursor(null)
	
func game_won_screen():
	$Transition/Blackscreen_Transition.win_game()
	
	


func _on_options_button_pressed() -> void:
	$Options_Menu.show()
	$Pause_Menu.hide()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	var main_screen = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(main_screen)
