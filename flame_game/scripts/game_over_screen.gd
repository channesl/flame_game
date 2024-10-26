extends Control


func set_top_label(text):
	$CenterContainer/VBoxContainer/MarginContainer/Label.text = text

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	var loading_screen = load("res://scenes/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	var main_screen = load("res://scenes/main_menu.tscn")
	get_tree().change_scene_to_packed(main_screen)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
