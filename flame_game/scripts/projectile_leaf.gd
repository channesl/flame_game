extends Area2D

@export var speed : float = 1
@export var damage : int = 10

@onready var shoot_audio = preload("res://scenes/audio/audio_stream_player_leaf_shoot.tscn")
@onready var hit_audio = preload("res://scenes/audio/audio_stream_player_leaf_hit.tscn")
@onready var audio_group = get_node("../../Audio")
@onready var collision_particles = preload("res://scenes/particles/leaf_collision_particles.tscn")
@onready var particles_group = get_node("../../Particles")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_spawn()

func _process(delta: float) -> void:
	position += (Vector2.RIGHT*speed).rotated(rotation)

func _on_body_entered(body: Node2D) -> void:
	if "is_possessed" in body:
		if body.is_possessed and !body.is_rage_active:
			body.expell_fire()
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


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
