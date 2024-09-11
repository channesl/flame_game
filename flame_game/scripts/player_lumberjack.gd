extends CharacterBody2D

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var player_fire : CharacterBody2D = %Player_Fire

@export var movement_speed : float = 200

signal get_possessed
signal not_possessed

var input_direction : Vector2 = Vector2.ZERO
var animation_locked : bool = false
var fire_in_area : bool = false
var is_possessed : bool = false

func _ready() -> void:
	player_fire.stop_possess.connect(set_is_possessed)
	
func _input(event: InputEvent) -> void:
	interact_fire()

func _physics_process(delta: float) -> void:
	
	movement()
	move_and_slide()
	update_facing_direction()
	update_animation()
	
	
	
func movement():
	if is_possessed:
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

func _on_area_2d_body_entered(body: Node2D) -> void:
	fire_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if !is_possessed:
		fire_in_area = false
	
func set_is_possessed():
	is_possessed = not is_possessed
	
func interact_fire():
	if fire_in_area:
		if Input.is_action_just_pressed("possess"):
			if !is_possessed:
				set_is_possessed()
				get_possessed.emit()
				%Player_Cam.set_to_follow(self)
			else:
				not_possessed.emit()
			
		
