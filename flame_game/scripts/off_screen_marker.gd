extends Node2D

@onready var sprite = $Sprite2D
@onready var icon = $Sprite2D/Sprite2D

var closest : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	closest = get_node("..").is_closest
	if closest:
		set_marker_position(Rect2(top_left, size))
		set_marker_rotation()
	
func set_marker_position(bounds : Rect2):
	sprite.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	sprite.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
		
func set_marker_rotation():
	var angle = (global_position - sprite.global_position).angle()
	sprite.global_rotation = angle
	icon.global_rotation = 0
