extends Control

var player 
var lumberjack
var perks_label

var button1_perk_number
var button2_perk_number
var button3_perk_number

signal perk_chosen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../../Player_Fire")
	lumberjack = get_node("../../Player_Lumberjack")
	perks_label = $MarginContainer/VBoxContainer/Level_Up_Perks


func init_level_up():
	set_perks_label()
	randomize_extra_perks()
	set_extra_perk_labels()
	
	
func set_perks_label():
	if player.current_level == 1:
		perks_label.text = "
		Ability Unlocked: Fireball [MouseButton 1]\n"
		player.fireball_unlocked = true
	if player.current_level == 2:
		perks_label.text = ""
		player.spawn_enemy_interval -= 5
	if player.current_level == 3:
		perks_label.text = "
		Ability Unlocked: Dash [Space] (Towards mouse position)\n"
		player.is_dash_unlocked = true
		player.spawn_enemy_interval -= 5
	if player.current_level == 4:
		perks_label.text = ""
		
		
func set_extra_perk_labels():
	$MarginContainer/VBoxContainer/VBoxContainer/Button1.text = get_extra_perk_label(button1_perk_number)
	$MarginContainer/VBoxContainer/VBoxContainer/Button2.text = get_extra_perk_label(button2_perk_number)
	$MarginContainer/VBoxContainer/VBoxContainer/Button3.text = get_extra_perk_label(button3_perk_number)
	
func get_extra_perk_label(perk_number) -> String:
	match perk_number:
		1:
			return "Increased burn time"
		2:
			return "Decreased attack cost"
		3:
			return "Increased speed"
		4:
			return "Increased attack speed"
		5:
			return "Increased attack damage"
		6:
			return "Unlock ability to spawn a minion that attacks enemies for you"
		7:
			return "Increased possessing strength (chance to not get expelled from lumberjack)"	
		8:
			return "Unlock rage. When activated the luberjack is not affected by enemy projectiles for 5 seconds. Cooldown 30 seconds."
		9:
			return "Unlock frenzy. When activated the fire can shoot fireballs much faster at zero cost for 5 seconds. Cooldown 30 seconds."
	return "Error"

func perform_extra_perk(perk_number) -> String:
	match perk_number:
		1:
			player.max_health += 50
			player.healthChanged.emit()
		2:
			player.fireball_cost -= 3
		3:
			player.movement_speed += 25
		4:
			player.shoot_cooldown_time -= 0.5
		5:
			player.damage += 5
		6:
			player.is_minion_unlocked = true
		7:
			lumberjack.chance_to_expell -= 0.30
		8:
			lumberjack.is_rage_unlocked = true
		9:
			player.is_frenzy_unlocked = true
	return "Error"
	
func randomize_extra_perks():
	var perks_list : Array
	match player.current_level:
		1: 
			perks_list = [1, 2, 3, 4, 5]
		2: 
			perks_list = [1, 2, 3, 4, 5]
		4: 
			perks_list = [1, 2, 3, 4, 5, 6, 7, 8]
		5: 
			perks_list = [1, 2, 3, 4, 5, 6, 7, 8, 9]
			
	if player.is_minion_unlocked and perks_list.find(6) != -1:
		perks_list.remove_at(perks_list.find(6))
	if lumberjack.is_rage_unlocked and perks_list.find(8) != -1:
		perks_list.remove_at(perks_list.find(8))
	if player.is_frenzy_unlocked and perks_list.find(9) != -1:
		perks_list.remove_at(perks_list.find(9))
	

	button1_perk_number = perks_list.pick_random()
	perks_list.remove_at(perks_list.find(button1_perk_number))
		
	button2_perk_number = perks_list.pick_random()
	perks_list.remove_at(perks_list.find(button2_perk_number))
		
	button3_perk_number = perks_list.pick_random()

func _on_button_1_pressed() -> void:
	perform_extra_perk(button1_perk_number)
	perk_chosen.emit()

func _on_button_2_pressed() -> void:
	perform_extra_perk(button2_perk_number)
	perk_chosen.emit()

func _on_button_3_pressed() -> void:
	perform_extra_perk(button3_perk_number)
	perk_chosen.emit()
