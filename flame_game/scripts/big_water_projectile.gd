extends Area2D

@export var damage : int = 10

@onready var shoot_audio = preload("res://scenes/audio/audio_stream_player_big_water_shoot.tscn")
@onready var audio_group = get_node("../../Audio")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = false
	on_spawn()

func _physics_process(delta: float) -> void:
	check_animation_frames()
	
func check_animation_frames():
	if $AnimatedSprite2D.frame > 2 and $AnimatedSprite2D.frame < 9:
		monitoring = true
	else:
		monitoring = false

func _on_body_entered(body: Node2D) -> void:
	if !"target_position" in body:
		if "fireball_unlocked" in body:
			if !body.is_possessing:
				body.current_health -= damage
			else:
				return
		elif "is_possessed" in body:
			if body.is_possessed and !body.is_rage_active:
				body.expell_fire()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func on_spawn():
	var new_shoot_audio_scene = shoot_audio.instantiate()
	audio_group.call_deferred("add_child", new_shoot_audio_scene)
	new_shoot_audio_scene.position = position
	new_shoot_audio_scene.play()
