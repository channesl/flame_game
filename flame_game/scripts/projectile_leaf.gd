extends Area2D

@export var speed : float = 1
@export var damage : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	position += (Vector2.RIGHT*speed).rotated(rotation)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "is_possessed" in body:
		if body.is_possessed and !body.is_rage_active:
			body.expell_fire()
	queue_free()
