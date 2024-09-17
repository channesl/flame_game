extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_fire : CharacterBody2D = %Player_Fire

@export var movement_speed : float = 200
@export var chop_cooldown_time : float = 1
@export var runaway_time : float = 4

signal get_possessed
signal not_possessed

var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var fire_in_area : bool = false
var is_possessed : bool = false
var chop_cooldown : bool = false
var is_running_away : bool = false
var runaway_direction : Vector2 = Vector2.ZERO

func _ready() -> void:
	player_fire.stop_possess.connect(set_is_possessed)
	$Chop_Cooldown.wait_time = chop_cooldown_time
	$Runaway_Timer.wait_time = runaway_time
	runaway()
	
func _input(event: InputEvent) -> void:
	interact_fire()

func _physics_process(delta: float) -> void:
	
	movement()
	move_and_slide()
	update_facing_direction()
	update_animation()
	update_light()
	
	
	
func movement():
	if is_possessed:
		input_direction = Vector2(
			Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		)
		
		input_direction = input_direction.normalized()
		
		velocity = input_direction * movement_speed
		
	if is_running_away:
		runaway_direction = runaway_direction.normalized()
		velocity = runaway_direction * movement_speed

func update_facing_direction():
	if velocity.x > 0:
		animated_sprite.flip_h = false
	elif velocity.x < 0:
		animated_sprite.flip_h = true

func update_animation():
	if not animation_locked:
		if !is_possessed:
			if velocity != Vector2.ZERO:
				animated_sprite.play("Running")
			else:
				animated_sprite.play("Idle")
		else:
			if velocity != Vector2.ZERO:
				animated_sprite.play("Running_Possessed")
			else:
				animated_sprite.play("Idle_Possessed")

func update_light():
	if is_possessed:
		$PointLight2D.enabled = true
		$PointLight2D2.enabled = true
	else:
		$PointLight2D.enabled = false
		$PointLight2D2.enabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	fire_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if !is_possessed:
		fire_in_area = false
	
func set_is_possessed():
	is_possessed = not is_possessed
	
func interact_fire():
	if fire_in_area:
		if Input.is_action_just_pressed("interact"):
			if !is_possessed:
				set_is_possessed()
				get_possessed.emit()
				%Player_Cam.set_to_follow(self)
				is_running_away = false
			else:
				not_possessed.emit()
			
func chop_tree() -> bool:
	if chop_cooldown:
		return false
	else:
		chop_cooldown = true
		$Chop_Cooldown.start()
		animation_locked = true
		animated_sprite.play("Chopping")
		return true


func _on_chop_cooldown_timeout() -> void:
	chop_cooldown = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Chopping":
		animation_locked = false

func expell_fire():
	player_fire.release_lumberjack()
	
func runaway():
	is_running_away = true
	var random = RandomNumberGenerator.new()
	random.randomize()
	var rand_x = random.randf_range(-1, 1)
	var rand_y = random.randf_range(-1, 1)
	runaway_direction = Vector2(rand_x, rand_y)
	$Runaway_Timer.start()


func _on_runaway_timer_timeout() -> void:
	is_running_away = false
	velocity = Vector2.ZERO
