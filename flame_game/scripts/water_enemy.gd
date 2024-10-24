extends CharacterBody2D

@onready var player : CharacterBody2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer : Timer = $ShootCooldownTimer
@onready var projectile : PackedScene = preload("res://scenes/projectile_water.tscn")
@onready var big_projectile : PackedScene = preload("res://scenes/big_water_projectile.tscn")


@export var speed : float = 300.0
@export var stop_range : float = 70.0
@export var maxHealth : int = 30
@export var shoot_cooldown_time : float = 1.5
@export var is_big : bool = false

var player_position
var target_position
var follow_player : bool = true
@onready var current_health : int = maxHealth
var shoot_cooldown : bool = true
var animation_locked : bool = false
var player_fire
var player_lumberjack

func _ready() -> void:
	player_fire = get_node("../../Player_Fire")
	player_lumberjack = get_node("../../Player_Lumberjack")
	set_follow_player()
	shoot_cooldown_timer.wait_time = shoot_cooldown_time
	#player.start_possess.connect(set_follow_player)
	#player.stop_possess.connect(set_follow_player)

func _physics_process(delta: float) -> void:
	move_to_player()
	update_facing_direction()
	update_animation()
	check_health()
	if is_big:
		shoot_big_water()
	else:
		shoot_water()
	set_follow_player()
	
func move_to_player():
	player_position = player.position
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
	if not animation_locked:
		if velocity != Vector2.ZERO:
			animated_sprite.play("Running")
		else:
			animated_sprite.play("Idle")
		
func set_follow_player():
	#follow_player = not player.is_possessing
	if player_fire.is_possessing:
		player = player_lumberjack
	else:
		player = player_fire
	
func check_health():
	if current_health <= 0:
		queue_free()

func shoot_water():
	if !shoot_cooldown and follow_player:
		var player_pos = player.position
		$Marker2D.look_at(player_pos)
		
		shoot_cooldown = true
		
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
	
func shoot_big_water():
	if !shoot_cooldown and follow_player:
		
		var player_pos = player.position
		
		shoot_cooldown = true
		shoot_cooldown_timer.wait_time = shoot_cooldown_time
		shoot_cooldown_timer.start()
		var projectile_instance = big_projectile.instantiate()
		projectile_instance.global_position = player_pos
		get_node("../../Projectiles").add_child(projectile_instance)
		animation_locked = true
		animated_sprite.play("Attacking")
		if player_pos.x - position.x > 0:
			animated_sprite.flip_h = false
		elif player_pos.x - position.x < 0:
			animated_sprite.flip_h = true

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Attacking":
		animation_locked = false


func _on_shoot_cooldown_timer_timeout() -> void:
	shoot_cooldown = false


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	shoot_cooldown = false
	shoot_cooldown_timer.paused = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	shoot_cooldown = true
	shoot_cooldown_timer.paused = true
