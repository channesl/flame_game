extends Area2D

@export var speed : float = 1

@onready var player
@onready var objective_ui = get_node("../../Objective/Objective_UI")

var damage

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player_Fire")
	damage = player.damage

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
	queue_free()
