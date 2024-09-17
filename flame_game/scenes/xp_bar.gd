extends TextureProgressBar

@export var player : CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.xpChanged.connect(update)
	update()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update() -> void:
	if player.current_level == 0:
		value = player.current_xp * 100 / player.level_1
	if player.current_level == 1:
		value = player.current_xp * 100 / player.level_2
	if player.current_level == 2:
		value = player.current_xp * 100 / player.level_3
