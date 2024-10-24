extends StaticBody2D

@export var max_health : int = 10
@export var damage : int = 20
@onready var current_health : int = max_health

@onready var log : PackedScene = preload("res://scenes/log.tscn")

@onready var boss_room : Node2D = get_node("../../")
@onready var animated_sprite : Node2D = $AnimatedSprite2D

var player_in_area : bool = false
var player : CharacterBody2D

var roots : Node2D

var has_damaged = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roots = get_node("..")
	
func _physics_process(delta: float) -> void:
	damage_player()
	check_health()
	
func damage_player():
	if player_in_area and animated_sprite.frame > 14 and !has_damaged:
		player.current_health -= damage
		player.healthChanged.emit()
		has_damaged = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if "is_possessing" in body:
		player_in_area = true
		player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if "is_possessing" in body:
		player_in_area = false



func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
		
func check_health():
	if current_health <= 0:
		var new_log_scene = log.instantiate()
		roots.call_deferred("add_child", new_log_scene)
		new_log_scene.position = position
		new_log_scene.position.y -= 5
		boss_room.roots_broken += 1
		queue_free()
		
