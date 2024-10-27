extends StaticBody2D

@export var max_health : int

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var boss_room : Node2D = get_node("..")
@onready var audio_heart : AudioStreamPlayer2D = $AudioStreamPlayer_Heart
@onready var start_position = position
@onready var death_audio = preload("res://scenes/audio/audio_stream_player_heart_death.tscn")
@onready var audio_group = get_node("../../Audio")
@onready var death_particles = preload("res://scenes/particles/heart_death_particles.tscn")
@onready var particles_group = get_node("../../Particles")

var current_health : int
var is_damageble : bool = false
var times_hit : int = 0
var audio_locked : bool = false
var time : float
var has_died : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	
func _process(delta: float) -> void:
	audio_heart_handler()
	if is_damageble:
		check_times_hit()
	if current_health <= 0:
		heart_death()
		move_pearl(delta)

func set_is_damageble():
	
	is_damageble =  !is_damageble
	if is_damageble:
		animated_sprite.play("Still")
	else:
		animated_sprite.play("Beating")
		
func check_times_hit():
	
	if times_hit >= 2:
		times_hit = 0
		set_is_damageble()
		boss_room.roots_active = true
		boss_room.current_stage += 1
		


func audio_heart_handler():
	if boss_room.boss_room_active:
		if animated_sprite.get_animation() == "Beating":
			if animated_sprite.frame == 4 and !audio_locked:
				audio_heart.play()
				audio_locked = true
				


func _on_animated_sprite_2d_animation_looped() -> void:
	audio_locked = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "is_possessing" in body and current_health <= 0:
		body.game_won.emit()

func heart_death():
	if !has_died:
		has_died = true
		animated_sprite.play("Dead")
		$Area2D.monitoring = true
		$CollisionShape2D.disabled = true
		var new_hit_audio_scene = death_audio.instantiate()
		audio_group.call_deferred("add_child", new_hit_audio_scene)
		new_hit_audio_scene.global_position = global_position
		new_hit_audio_scene.play()
		var new_particles_scene = death_particles.instantiate()
		particles_group.call_deferred("add_child", new_particles_scene)
		new_particles_scene.global_position = global_position
		new_particles_scene.emitting = true

func move_pearl(delta):
	time += delta
	position = start_position + Vector2(0, get_sin())

func get_sin() -> float:
	return sin(time*3)*5
