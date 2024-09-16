extends CharacterBody2D

@onready var player : CharacterBody2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer : Timer = $ShootCooldownTimer
@onready var projectile : PackedScene = preload("res://scenes/projectile_water.tscn")

@export var speed : float = 300.0
@export var stop_range : float = 70.0
@export var maxHealth : int = 30
@export var shoot_cooldown_time : float = 1.5

var player_position
var target_position
var follow_player : bool = true
var current_health : int = 30
var shoot_cooldown : bool = false
var animation_locked : bool = false

func _ready() -> void:
	player = get_node("../../Player_Fire")
	print(player)
	player.start_possess.connect(set_follow_player)
	player.stop_possess.connect(set_follow_player)

func _physics_process(delta: float) -> void:
	move_to_player()
	update_facing_direction()
	check_health()
	shoot_water()
	
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
		
func set_follow_player():
	follow_player = not follow_player
	
func check_health():
	if current_health <= 0:
		player.current_xp += 5
		queue_free()

func shoot_water():
	if !shoot_cooldown and follow_player:
		var player_pos = player.position
		$Marker2D.look_at(player_pos)
		
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
	


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Attacking":
		animation_locked = false


func _on_shoot_cooldown_timer_timeout() -> void:
	shoot_cooldown = false
