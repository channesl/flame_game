extends StaticBody2D

@export var added_health : int
@export var added_xp : int
@export var is_magic : bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.get_is_possessing():
		body.current_health += added_health
		body.healthChanged.emit()
		body.current_xp += added_xp
		body.xpChanged.emit()
		if is_magic:
			body.current_level += 1
			body.level_up.emit()
		queue_free()
