extends Area2D

@export var damage : int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false

func _physics_process(delta: float) -> void:
	check_animation_frames()
	
func check_animation_frames():
	if $AnimatedSprite2D.frame > 2 and $AnimatedSprite2D.frame < 9:
		monitoring = true
	else:
		monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if !"target_position" in body:
		if "fireball_unlocked" in body:
			if !body.is_possessing:
				body.current_health -= damage
			else:
				return
		elif "is_possessed" in body:
			if body.is_possessed and !body.is_rage_active:
				body.expell_fire()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
