extends Camera2D

@export var randomStrength: float = 30.0
@export var shakeFade: float = 5.0

@onready var node_to_follow = %Player_Fire
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


func _physics_process(delta: float) -> void:
	position = node_to_follow.position
	
func set_to_follow(player: CharacterBody2D):
	node_to_follow = player




var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

func apply_shake():
	shake_strength = randomStrength

func _process(delta):
	
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
