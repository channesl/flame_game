extends StaticBody2D


@onready var label : Label = $Label
@onready var log : PackedScene = preload("res://scenes/log.tscn")

@export var max_health : int = 3

var text_percent_visible : float = 0.0
var text_length : int = 15
var player_in_area : bool = false
var current_health : int = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible_ratio = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	chop_down()


func _on_area_2d_body_entered(body: Node2D) -> void:
	player_in_area = true
	$Label/Timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false
	$Label/Timer.start()
 

func _on_timer_timeout() -> void:
	if player_in_area == true:
		label.visible_ratio += 1.0/15.0
		if label.visible_ratio >= 1:
			$Label/Timer.stop()
	else:
		label.visible_ratio -= 1.0/15.0
		if label.visible_ratio <= 0:
			$Label/Timer.stop()
			
func chop_down() -> void:
	if player_in_area == true:
		if %Player_Lumberjack.is_possessed:
			if Input.is_action_just_pressed("shoot"):
				current_health -= 1
				if current_health <= 0:
					var new_log_scene = log.instantiate()
					%Trees.call_deferred("add_child", new_log_scene)
					new_log_scene.position = position
					queue_free()
				
			
			
			
			
			
			
			
			
			
