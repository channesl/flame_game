extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_fire : CharacterBody2D = %Player_Fire
@onready var audio_chop : AudioStreamPlayer2D = $Audio/AudioStreamPlayer_Chop
@onready var audio_chop_leaf : AudioStreamPlayer2D = $Audio/AudioStreamPlayer_Chop_Leaf
@onready var audio_rage : AudioStreamPlayer2D = $Audio/AudioStreamPlayer_Rage
@onready var audio_running : AudioStreamPlayer2D = $Audio/AudioStreamPlayer_Running

@export var movement_speed : float = 200
@export var chop_cooldown_time : float = 1
@export var runaway_time : float = 4
@export var rage_time : float = 10
@export var rage_cooldown_time : float = 30

signal get_possessed
signal not_possessed
signal rage_activated
signal chop_activated

var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var fire_in_area : bool = false
var is_possessed : bool = false
var chop_cooldown : bool = false
var is_running_away : bool = false
var runaway_direction : Vector2 = Vector2.ZERO

var chance_to_expell : float = 1.0

var is_rage_unlocked : bool = false
var rage_cooldown : bool = false
var is_rage_active : bool = false

func _ready() -> void:
	player_fire.stop_possess.connect(set_is_possessed)
	$Chop_Cooldown.wait_time = chop_cooldown_time
	$Runaway_Timer.wait_time = runaway_time
	$Rage_Cooldown_Timer.wait_time = rage_cooldown_time
	runaway()
	interact_fire_start()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		interact_fire()
	elif Input.is_action_just_pressed("Ability1"):
		activate_rage()

func _physics_process(delta: float) -> void:
	
	movement()
	move_and_slide()
	update_facing_direction()
	update_animation()
	update_light()
	audio_running_handler()
	
	
	
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

func interact_fire_start():
	if !is_possessed:
		set_is_possessed()
		get_possessed.emit()
		%Player_Cam.set_to_follow(self)
		is_running_away = false
	else:
		not_possessed.emit()
			
func chop_tree(object) -> bool:
	if chop_cooldown:
		return false
	else:
		chop_cooldown = true
		$Chop_Cooldown.start()
		animation_locked = true
		animated_sprite.play("Chopping")
		chop_activated.emit()
		if object == "tree":
			audio_chop.play()
		else:
			audio_chop_leaf.play()
		return true


func _on_chop_cooldown_timeout() -> void:
	chop_cooldown = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.get_animation() == "Chopping":
		animation_locked = false

func expell_fire():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var rand = random.randf_range(0, 1)
	if rand <= chance_to_expell:
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
	
func activate_rage():
	if is_rage_unlocked and !rage_cooldown:
		is_rage_active = true
		rage_cooldown = true
		chop_cooldown_time *= 0.5
		$Rage_Cooldown_Timer.start()
		rage_activated.emit()
		audio_rage.play()


func _on_rage_cooldown_timer_timeout() -> void:
	rage_cooldown = false
	chop_cooldown_time *= 2

func audio_running_handler():
	if !audio_running.playing and !audio_running.stream_paused:
		audio_running.play()
	if velocity != Vector2.ZERO:
		audio_running.stream_paused = false
	else:
		audio_running.stream_paused = true
		
