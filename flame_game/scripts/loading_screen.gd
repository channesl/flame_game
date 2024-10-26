extends Control

var scene_name
var scene_load_status = 0
var min_time : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scene_name = "res://scenes/game.tscn"
	ResourceLoader.load_threaded_request(scene_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(scene_name)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED and min_time:
		var new_scene = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(new_scene)


func _on_timer_timeout() -> void:
	min_time = true
