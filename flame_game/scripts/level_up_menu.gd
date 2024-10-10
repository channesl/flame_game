extends Control

var player 
var perks_label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player_Fire")
	perks_label = $MarginContainer/VBoxContainer/Level_Up_Perks


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_perks_label():
	if player.current_level == 1:
		perks_label.text = "+ Burn Time"
	if player.current_level == 2:
		perks_label.text = "
		+ Burn Time\n
		+ Attack Damage"
	if player.current_level == 3:
		perks_label.text = "
		+ Speed"
		



func _on_button_1_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	pass # Replace with function body.
