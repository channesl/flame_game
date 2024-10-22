extends StaticBody2D

@export var max_health : int

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var current_health : int
var is_damageble : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health

func set_is_damageble():
	is_damageble =  !is_damageble
	if is_damageble:
		animated_sprite.play("Still")
	else:
		animated_sprite.play("Beating")
