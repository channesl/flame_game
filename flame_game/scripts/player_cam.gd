extends Camera2D

@onready var node_to_follow = %Player_Fire
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	make_current()


func _physics_process(delta: float) -> void:
	position = node_to_follow.position
	
func set_to_follow(player: CharacterBody2D):
	node_to_follow = player
