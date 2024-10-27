extends Control

@onready var original_modulate = modulate

func game_start():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	tween.tween_callback(hide)
	
func enter_tree(player, player_wanted_pos):
	var tween = get_tree().create_tween()
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", original_modulate, 1)
	tween.tween_callback(transport_player.bind(player, player_wanted_pos))
	tween.tween_interval(1.5)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	tween.tween_callback(hide)
	
func win_game():
	var tween = get_tree().create_tween()
	tween.tween_callback(show)
	tween.tween_property(self, "modulate", original_modulate, 1)
	tween.tween_callback(change_scene_win)

func change_scene_win():
	var end_cut_screen = load("res://scenes/end_cut_scene.tscn")
	get_tree().change_scene_to_packed(end_cut_screen)

func transport_player(player, player_wanted_pos):
	player.position = player_wanted_pos
