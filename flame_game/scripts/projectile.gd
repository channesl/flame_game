extends Area2D

@export var speed : float = 1

@onready var player

var damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player_Fire")
	damage = player.damage

func _process(delta: float) -> void:
	position += (Vector2.RIGHT*speed).rotated(rotation)

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "player_position" in body:
		body.current_health -= damage
	queue_free()
