extends Area2D

@export var speed : float = 1
@export var damage : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	position += (Vector2.RIGHT*speed).rotated(rotation)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if !"target_position" in body:
		if "fireball_unlocked" in body:
			if !body.is_possessing:
				body.current_health -= damage
			else:
				return
		elif "is_possessed" in body:
			body.expell_fire()
		queue_free()
