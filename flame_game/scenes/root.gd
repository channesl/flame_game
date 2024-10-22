extends StaticBody2D

@export var max_health : int = 10
@export var damage : int = 20
@onready var current_health : int = max_health

@onready var log : PackedScene = preload("res://scenes/log.tscn")

var player_in_area : bool = false
var player : CharacterBody2D

var roots : Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roots = get_node("..")

func _physics_process(delta: float) -> void:
	if $AnimatedSprite2D.frame > 14:
		$Area2D.monitorable = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "is_possessing" in body:
		player_in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "is_possessing" in body:
		player_in_area = false



func _on_animated_sprite_2d_animation_finished() -> void:
	if player_in_area:
		player.current_health -= damage
		
func check_health():
	if current_health <= 0:
		var new_log_scene = log.instantiate()
		roots.call_deferred("add_child", new_log_scene)
		new_log_scene.position = position
		
