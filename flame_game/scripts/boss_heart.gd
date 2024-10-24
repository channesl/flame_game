extends StaticBody2D

@export var max_health : int

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var boss_room : Node2D = get_node("..")


var current_health : int
var is_damageble : bool = false
var times_hit : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	
func _process(delta: float) -> void:
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
		
