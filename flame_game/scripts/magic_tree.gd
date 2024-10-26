extends StaticBody2D

@export var boss_room : Node2D

signal enters_boss_room

@onready var objective_ui = get_node("../../Objective/Objective_UI")
@onready var original_modulate = modulate

var objects_behind_tree = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	make_transparent()


func open_tree():
	$Tree_Sprite.frame = 1
	$Veins_Sprite.frame = 1
	$Enter_Area.monitoring = true

func _on_enter_area_body_entered(body: Node2D) -> void:
	if "is_possessing" in body:
		body.position = boss_room.get_child(-1).global_position
		body.is_in_boss_room = true
		enters_boss_room.emit()
		objective_ui.current_objective += 1

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
