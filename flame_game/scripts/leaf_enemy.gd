extends CharacterBody2D

@onready var lumberjack : CharacterBody2D
@onready var player : CharacterBody2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer : Timer = $ShootCooldownTimer
@onready var projectile : PackedScene = preload("res://scenes/projectile_leaf.tscn")

@export var speed : float = 300.0
@export var stop_range : float = 70.0
@export var maxHealth : int = 3
@export var shoot_cooldown_time : float = 3

var player_position
var target_position
var follow_player : bool = true
var current_health : int
var shoot_cooldown : bool = true
var animation_locked : bool = false
var player_in_area : bool = false
var mouse_in_area : bool = false

func _ready() -> void:
	current_health = maxHealth
	lumberjack = get_node("../../Player_Lumberjack")
	player = get_node("../../Player_Fire")
	shoot_cooldown_timer.start()

func _physics_process(_delta: float) -> void:
	move_to_player()
	update_facing_direction()
	update_animation()
	check_health()
	shoot_leaf()
	set_follow_player()
	chop_down()
	
func move_to_player():
	player_position = lumberjack.position
	target_position = (player_position - position).normalized()
	
	if follow_player:
		if position.distance_to(player_position) > stop_range:
			velocity = Vector2(target_position * speed) 
			move_and_slide()

func update_facing_direction():
	if target_position.x > 0:
		animated_sprite.flip_h = false
	elif target_position.x < 0:
		animated_sprite.flip_h = true
		
func update_animation():
	if !animation_locked:
		if velocity != Vector2.ZERO:
			animated_sprite.play("Running")
		else:
			animated_sprite.play("Idle")
		
func set_follow_player():
	follow_player = lumberjack.is_possessed
	
func check_health():
	if current_health <= 0:
		queue_free()

func shoot_leaf():
	if !shoot_cooldown and follow_player:
		var player_pos = lumberjack.position
		$Marker2D.look_at(player_pos- Vector2(0, -5))
		
		shoot_cooldown = true
		shoot_cooldown_timer.wait_time = shoot_cooldown_time
		shoot_cooldown_timer.start()
		var projectile_instance = projectile.instantiate()
		projectile_instance.rotation = $Marker2D.rotation
		projectile_instance.global_position = $Marker2D.global_position
		get_node("../../Projectiles").add_child(projectile_instance)
		animation_locked = true
		animated_sprite.play("Attacking")
		if player_pos.x - position.x > 0:
			animated_sprite.flip_h = false
		elif player_pos.x - position.x < 0:
			animated_sprite.flip_h = true
	

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot_cooldown = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Attacking":
		animation_locked = false

func chop_down() -> void:
	if player_in_area and mouse_in_area:
		if Input.is_action_just_pressed("shoot"):
			if lumberjack.chop_tree():
				current_health -= 1

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player_in_area = true
	
func _on_area_2d_body_exited(_body: Node2D) -> void:
	player_in_area = false
	
	


func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true


func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false
