extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_lumberjack : CharacterBody2D = %Player_Lumberjack

@export var movement_speed : float = 200

var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var is_possessing : bool = false

func _physics_process(delta: float) -> void:
	
	movement()
	move_and_slide()
	update_facing_direction()
	update_animation()
	release_lumberjack()
	set_visability()
	
func movement():
	
	if !is_possessing:
		input_direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)
		
		input_direction = input_direction.normalized()
		
		velocity = input_direction * movement_speed

func update_facing_direction():
	if input_direction.x > 0:
		animated_sprite.flip_h = false
	elif input_direction.x < 0:
		animated_sprite.flip_h = true

func update_animation():
	if not animation_locked:
		if input_direction != Vector2.ZERO:
			animated_sprite.play("Running")
		else:
			animated_sprite.play("Idle")

func release_lumberjack():
	if is_possessing:
		if Input.is_action_just_pressed("shoot"):
			print("fire")
			player_lumberjack.is_possessed = false
			is_possessing = false
			$Camera2D.make_current()
			position = player_lumberjack.position
			
func set_visability():
	if is_possessing:
		visible = false
	else:
		visible = true
