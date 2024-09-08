extends CharacterBody2D

signal healthChanged

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_lumberjack : CharacterBody2D = %Player_Lumberjack
@onready var current_health : int = max_health

@export var movement_speed : float = 200
@export var max_health : int = 100


var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var is_possessing : bool = false

func _ready() -> void:
	#%Fire_Cam.make_current()
	pass

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
		position = player_lumberjack.position
		if Input.is_action_just_pressed("shoot"):
			print("fire")
			player_lumberjack.is_possessed = false
			is_possessing = false
			%Player_Cam.set_to_follow(self)
			#%Fire_Cam.make_current()
			
			
func set_visability():
	if is_possessing:
		visible = false
	else:
		visible = true
		
func get_is_possessing() -> bool:
	return is_possessing
	
func update_health() -> void:
	if current_health > max_health:
		current_health = max_health
	if is_possessing:
		current_health -= 3
	else:
		current_health -= 5
	healthChanged.emit()
	
func _on_timer_timeout() -> void:
	update_health()
