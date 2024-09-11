extends CharacterBody2D

signal healthChanged
signal start_possess
signal stop_possess

@onready var projectile : PackedScene = preload("res://scenes/projectile.tscn")
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_lumberjack : CharacterBody2D = %Player_Lumberjack
@onready var current_health : int = max_health

@export var movement_speed : float = 200
@export var max_health : int = 100


var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var is_possessing : bool = false
var fireball_unlocked : bool = true

func _ready() -> void:
	player_lumberjack.get_possessed.connect(set_is_possessing)
	player_lumberjack.not_possessed.connect(release_lumberjack)
	
func _input(event: InputEvent) -> void:
	if !is_possessing:
		shoot_fireball()

func _physics_process(delta: float) -> void:
	
	if !is_possessing:
		movement()
		move_and_slide()
		update_facing_direction()
		update_animation()
		
	set_visability()
	
	
func movement():
	
	input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
		
	input_direction = input_direction.normalized()
		
	velocity = input_direction * movement_speed

func update_facing_direction():
	if not animation_locked:
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
	position = player_lumberjack.position
	stop_possess.emit()
	set_is_possessing()
	%Player_Cam.set_to_follow(self)

			
func set_is_possessing():
	if !is_possessing:
		start_possess.emit()
	is_possessing = not is_possessing
			
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
	if current_health <= 0:
		current_health = 0
	if is_possessing:
		current_health -= 0
	else:
		current_health -= 5
	healthChanged.emit()
	
	
func _on_timer_timeout() -> void:
	update_health()
	
func shoot_fireball():
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("shoot") and fireball_unlocked:
		var projectile_instance = projectile.instantiate()
		projectile_instance.rotation = $Marker2D.rotation
		projectile_instance.global_position = $Marker2D.global_position
		%Projectiles.add_child(projectile_instance)
		animation_locked = true
		animated_sprite.play("Attacking")
		if mouse_pos.x - position.x > 0:
			animated_sprite.flip_h = false
		elif mouse_pos.x - position.x < 0:
			animated_sprite.flip_h = true
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Attacking":
		animation_locked = false
