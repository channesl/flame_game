extends TextureProgressBar

@export var player : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.healthChanged.connect(update)
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update() -> void:
	value = player.current_health * 100 / player.max_health
