extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/MarginContainer/VBoxContainer/MarginContainer/CenterContainer/VBoxContainer/Play_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	start_animation()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options_menu.tscn")

func start_animation():
	var tween = get_tree().create_tween()
	tween.tween_callback(set_object_visible.bind("log"))
	tween.tween_interval(0.5)
	tween.tween_property(%Log, "modulate", Color(0.5,0.5,0.5,1),0.5).set_ease(Tween.EaseType.EASE_IN)
	tween.tween_property(%Log, "position", %Log.position + Vector2(0,300),0.5).set_ease(Tween.EaseType.EASE_IN)
	tween.tween_callback(%Log.queue_free)
	tween.tween_callback(set_object_visible.bind("fire"))
	tween.tween_interval(0.5)
	tween.tween_property(%Fire, "position", %Fire.position + Vector2(250,-66),0.5).set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_callback(%Fire.queue_free)
	tween.tween_callback(change_animation)
	tween.tween_interval(1)
	tween.tween_callback(change_to_game_scene)
	
	
func set_object_visible(object):
	if object == "log":
		%Log.show()
	elif object == "fire":
		%Fire.show()
		
func change_animation():
	%Lumberjack.play("Possessed")
	
func change_to_game_scene():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
