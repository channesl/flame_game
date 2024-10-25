extends Area2D

@export var speed : float = 1

@onready var player
@onready var objective_ui = get_node("../../Objective/Objective_UI")
@onready var shoot_audio = preload("res://scenes/audio/audio_stream_player_shoot.tscn")
@onready var hit_audio = preload("res://scenes/audio/audio_stream_player_hit.tscn")
@onready var audio_group = get_node("../../Audio")
@onready var collision_particles = preload("res://scenes/particles/fire_collision_particles.tscn")
@onready var particles_group = get_node("../../Particles")

var damage
var has_hit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player_Fire")
	damage = player.damage
	on_spawn()

func _physics_process(delta: float) -> void:
	position += (Vector2.RIGHT*speed).rotated(rotation)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "player_position" in body:
		body.current_health -= damage
	if "has_damaged" in body:
		if body.animated_sprite.frame > 14:
			body.current_health -= damage
	if "is_damageble" in body:
		if body.is_damageble:
			body.current_health -= 1
			body.times_hit += 1
			objective_ui.progress += 1
	hit_object()
	
func on_spawn():
	var new_shoot_audio_scene = shoot_audio.instantiate()
	audio_group.call_deferred("add_child", new_shoot_audio_scene)
	new_shoot_audio_scene.position = position
	new_shoot_audio_scene.play()

func hit_object():
	var new_hit_audio_scene = hit_audio.instantiate()
	audio_group.call_deferred("add_child", new_hit_audio_scene)
	new_hit_audio_scene.position = position
	new_hit_audio_scene.play()
	var new_particles_scene = collision_particles.instantiate()
	particles_group.call_deferred("add_child", new_particles_scene)
	new_particles_scene.position = position
	new_particles_scene.emitting = true
	queue_free()
	
