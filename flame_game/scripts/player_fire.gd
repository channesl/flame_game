extends CharacterBody2D

signal healthChanged
signal xpChanged
signal start_possess
signal stop_possess
signal level_up

@onready var water_enemy : PackedScene = preload("res://scenes/water_enemy.tscn")
@onready var projectile : PackedScene = preload("res://scenes/projectile.tscn")
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_lumberjack : CharacterBody2D = %Player_Lumberjack
@onready var current_health : int = max_health
@onready var shoot_cooldown_timer : Timer = $ShootCooldownTimer

@export var movement_speed : float
@export var max_health : int
@export var spawn_enemy_interval : float

@export_subgroup("Fireball")
@export var shoot_cooldown_time : float
@export var fireball_cost : int
@export var damage : int

@export_subgroup("Time Damage")
@export var time_damage : int
@export var time_damage_possessing : int
@export var loose_health_time : float

@export_subgroup("Level Caps")
@export var level_1 : int
@export var level_2 : int
@export var level_3 : int

@export_subgroup("Frenzy")
@export var frenzy_duration : float
@export var frenzy_cooldown_time : float

var shoot_cooldown : bool = false
var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var is_possessing : bool = false
var fireball_unlocked : bool = true
var current_level : int = 0
var current_xp : int = 0

var is_spawn_minion_unlocked : bool = false

var is_frenzy_unlocked : bool = false
var frenzy_cooldown : bool = false
var frenzy_active : bool = false

func _ready() -> void:
	player_lumberjack.get_possessed.connect(set_is_possessing)
	player_lumberjack.not_possessed.connect(release_lumberjack)
	$Timer.wait_time = loose_health_time
	$Spawn_Enemy.wait_time = spawn_enemy_interval
	$Frenzy_Duration_Timer.wait_time = frenzy_duration
	$Frenzy_Cooldown_Timer.wait_time = frenzy_cooldown_time
	
func _input(event: InputEvent) -> void:
	if !is_possessing:
		if Input.is_action_just_pressed("shoot"):
			shoot_fireball()
		elif Input.is_action_just_pressed("Ability1"):
			activate_frenzy()

func _physics_process(delta: float) -> void:
	
	if !is_possessing:
		movement()
		move_and_slide()
		update_facing_direction()
		update_animation()
		update_particles()
		
	set_visability()
	check_xp()
	
func movement():
	
	input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
		
	input_direction = input_direction.normalized()
		
	velocity = input_direction * movement_speed

func update_facing_direction():
	if not animation_locked:
		if velocity.x > 0:
			animated_sprite.flip_h = false
		elif velocity.x < 0:
			animated_sprite.flip_h = true

func update_animation():
	if not animation_locked:
		if velocity != Vector2.ZERO:
			animated_sprite.play("Running")
		else:
			animated_sprite.play("Idle")

func release_lumberjack():
	position = player_lumberjack.position
	stop_possess.emit()
	set_is_possessing()
	%Player_Cam.set_to_follow(self)
	player_lumberjack.runaway()

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
		current_health -= time_damage_possessing
	else:
		current_health -= time_damage
	healthChanged.emit()
	
func _on_timer_timeout() -> void:
	update_health()
	
func shoot_fireball():
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("shoot") and fireball_unlocked and !shoot_cooldown:
		shoot_cooldown = true
		shoot_cooldown_timer.wait_time = shoot_cooldown_time
		shoot_cooldown_timer.start()
		if !frenzy_active:
			current_health -= fireball_cost
			healthChanged.emit()
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

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot_cooldown = false
	
func spawn_enemy() -> void:
	if %Enemies.get_child_count() < 5 and current_level > 0:
		var random = RandomNumberGenerator.new()
		random.randomize()
		$Path2D/PathFollow2D.progress_ratio = random.randf_range(0, 1)
		
		var water_enemy_instance = water_enemy.instantiate()
		water_enemy_instance.global_position = %Enemy_Spawn_Postition.global_position
		%Enemies.add_child(water_enemy_instance)
	

func _on_spawn_enemy_timeout() -> void:
	spawn_enemy()
	
func check_xp():
	if current_level == 0:
		if current_xp >= level_1:
			current_level = 1
			current_xp -= level_1
			xpChanged.emit()
	if current_level == 1:
		if current_xp >= level_2:
			current_level = 2
			current_xp -= level_2
			xpChanged.emit()
	if current_level == 2:
		if current_xp >= level_3:
			current_level = 3
			current_xp -= level_3
			xpChanged.emit()
			
func update_particles():
	var particle_direction = (player_lumberjack.position - position).normalized()
	$CPUParticles2D.direction = particle_direction

func activate_frenzy():
	if is_frenzy_unlocked and !frenzy_cooldown:
		frenzy_active = true
		$Frenzy_Duration_Timer.start()
		frenzy_cooldown = true
		shoot_cooldown_time *= 0.5

func _on_frenzy_duration_timer_timeout() -> void:
	frenzy_active = false
	shoot_cooldown_time *= 2
	$Frenzy_Cooldown_Timer.start()

func _on_frenzy_cooldown_timer_timeout() -> void:
	frenzy_cooldown = false
