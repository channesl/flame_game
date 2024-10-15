extends CharacterBody2D

@onready var enemy : CharacterBody2D
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_cooldown_timer : Timer = $ShootCooldownTimer
@onready var projectile : PackedScene = preload("res://scenes/projectile.tscn")

@export var speed : float = 300.0
@export var stop_range : float = 70.0
@export var shoot_cooldown_time : float = 1.5
@export var lifetime : float = 15

var enemy_position
var target_position
var follow_enemy : bool = true

var shoot_cooldown : bool = true
var animation_locked : bool = false
var enemies

func _ready() -> void:
	enemies = get_node("../../Enemies")
	set_follow_enemy()
	$LifeTimer.wait_time = lifetime

func _physics_process(delta: float) -> void:
	move_to_enemy()
	update_facing_direction()
	update_animation()
	shoot_fire()
	set_follow_enemy()
	
func move_to_enemy():
	if enemy == null:
		pass
	else:
		enemy_position = enemy.position
		target_position = (enemy_position - position).normalized()
		
		if follow_enemy:
			if position.distance_to(enemy_position) > stop_range:
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
		
func set_follow_enemy():
	enemy = get_closest_enemy()
	

func shoot_fire():
	if enemy == null:
		pass
	else:
		if !shoot_cooldown and follow_enemy:
			var enemy_pos = enemy.position
			$Marker2D.look_at(enemy_pos)
			
			shoot_cooldown = true
			shoot_cooldown_timer.wait_time = shoot_cooldown_time
			shoot_cooldown_timer.start()
			var projectile_instance = projectile.instantiate()
			projectile_instance.rotation = $Marker2D.rotation
			projectile_instance.global_position = $Marker2D.global_position
			get_node("../../Projectiles").add_child(projectile_instance)
			animation_locked = true
			animated_sprite.play("Attacking")
			if enemy_pos.x - position.x > 0:
				animated_sprite.flip_h = false
			elif enemy_pos.x - position.x < 0:
				animated_sprite.flip_h = true
		

func get_closest_enemy() -> Node2D:
	var closest : Node2D = null
	var closest_distance : float = INF
	
	for node : Node2D in enemies.get_children():
		var distance = position.distance_squared_to(node.global_position)
		if distance < closest_distance:
			closest = node
			closest_distance = distance
	
	return closest

	
func _on_shoot_cooldown_timer_timeout() -> void:
	shoot_cooldown = false


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	shoot_cooldown = false
	shoot_cooldown_timer.paused = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	shoot_cooldown = true
	shoot_cooldown_timer.paused = true


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Attacking":
		animation_locked = false



func _on_life_timer_timeout() -> void:
	queue_free()
