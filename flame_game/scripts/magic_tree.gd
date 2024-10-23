extends StaticBody2D

@export var boss_room : Node2D

signal enters_boss_room

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open_tree()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_tree():
	$Tree_Sprite.frame = 1
	$Veins_Sprite.frame = 1
	$Enter_Area.monitoring = true

func _on_enter_area_body_entered(body: Node2D) -> void:
	if "is_possessing" in body:
		body.position = boss_room.get_child(-1).global_position
		body.is_in_boss_room = true
		enters_boss_room.emit()
