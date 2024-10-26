extends StaticBody2D

@export var max_health : int

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var boss_room : Node2D = get_node("..")
@onready var audio_heart : AudioStreamPlayer2D = $AudioStreamPlayer_Heart

var current_health : int
var is_damageble : bool = false
var times_hit : int = 0
var audio_locked : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	
func _process(delta: float) -> void:
	audio_heart_handler()
	if is_damageble:
		check_times_hit()

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
