extends StaticBody2D


@onready var log : PackedScene = preload("res://scenes/log.tscn")
@onready var magic_log : PackedScene = preload("res://scenes/magic_log.tscn")
@onready var leaf_enemy : PackedScene = preload("res://scenes/leaf_enemy.tscn")
@onready var audio_falling : PackedScene = preload("res://scenes/audio/audio_stream_player_tree_falling.tscn")
@onready var audio_group = get_node("../../Audio")
@onready var original_modulate = modulate

@export var max_health : int = 10
@export var is_magic : bool

var text_percent_visible : float = 0.0
var text_length : int = 15
var player_in_area : bool = false
var mouse_in_area : bool = false
var current_health : int
var objects_behind_tree : int = 0

var lumberjack
var trees
var enemies

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	lumberjack = get_node("../../Player_Lumberjack")
	trees = get_node("../../Trees")
	enemies = get_node("../../Enemies")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	chop_down()
	make_transparent()


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false
 
			
func chop_down() -> void:
	if player_in_area and mouse_in_area:
		if lumberjack.is_possessed:
			if Input.is_action_just_pressed("shoot"):
				if lumberjack.chop_tree("tree"):
					current_health -= 1
					if current_health <= 0:
						if is_magic:
							var new_log_scene = magic_log.instantiate()
							trees.call_deferred("add_child", new_log_scene)
							new_log_scene.position = position
						else:
							var random = RandomNumberGenerator.new()
							random.randomize()
							var rand = random.randf_range(0, 1)
							if rand < 0.8:
								var new_log_scene = log.instantiate()
								trees.call_deferred("add_child", new_log_scene)
								new_log_scene.position = position
							else:
								var new_leaf_scene = leaf_enemy.instantiate()
								enemies.call_deferred("add_child", new_leaf_scene)
								new_leaf_scene.position = position
						queue_free()
						var new_audio_scene = audio_falling.instantiate()
						audio_group.call_deferred("add_child", new_audio_scene)
						new_audio_scene.position = position
						

func _on_area_2d_mouse_entered() -> void:
	mouse_in_area = true

func _on_area_2d_mouse_exited() -> void:
	mouse_in_area = false



func _on_transparent_behind_body_entered(body: Node2D) -> void:
	if "is_possessing" in body or "is_possessed" in body:
		objects_behind_tree += 1

func _on_transparent_behind_body_exited(body: Node2D) -> void:
	if "is_possessing" in body or "is_possessed" in body:
		objects_behind_tree -= 1

func make_transparent():
	var tween = get_tree().create_tween()
	if objects_behind_tree > 0:
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.5), 0.2)
	else:
		tween.tween_property(self, "modulate", original_modulate ,0.2)
