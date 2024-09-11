extends CharacterBody2D

@onready var player : CharacterBody2D = %Player_Fire
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var speed : float = 300.0
@export var stop_range : float = 5.0
@export var maxHealth : int = 30

var player_position
var target_position
var follow_player : bool = true
var current_health : int = 30

func _ready() -> void:
	player.start_possess.connect(set_follow_player)
	player.stop_possess.connect(set_follow_player)

func _physics_process(delta: float) -> void:
	move_to_player()
	update_facing_direction()
	check_health()
	
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
		queue_free()
