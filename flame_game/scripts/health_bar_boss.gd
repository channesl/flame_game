extends Control

@onready var boss_heart = get_node("../../Boss_Room/Boss_Heart")
@onready var boss_room = get_node("../../Boss_Room")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if boss_room.boss_room_active:
		show()
	$TextureProgressBar.value = boss_heart.current_health
