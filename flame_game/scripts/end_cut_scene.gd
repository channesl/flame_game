extends Node2D


@onready var original_modulate = %Game_Over_Screen.modulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Game_Over_Screen.modulate = Color(1, 1, 1, 0)
	start_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func start_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(%Blackscreen, "modulate", Color(1, 1, 1, 0), 1)
	tween.tween_property($Fire, "scale", Vector2(2, 2),2.5)
	tween.tween_callback(set_menu_visible)
	tween.tween_interval(0.5)
	tween.tween_property(%Game_Over_Screen, "modulate", original_modulate, 0.5)
	

func set_menu_visible():
	$CanvasLayer/Game_Over_Screen.show()
