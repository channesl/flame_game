extends Control

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))


func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))


func _on_ambiance_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(3, linear_to_db(value))


func _on_back_button_pressed() -> void:
	get_node("..").hide()
	get_node("../../Pause_Menu").show()


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
