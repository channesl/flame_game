extends Control

@export var fire : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fire.frenzy_activated.connect(frenzy_activated)
	fire.minion_activated.connect(minion_activated)
	fire.dash_activated.connect(dash_activated)
	fire.shoot_activated.connect(shoot_activated)

func _physics_process(delta: float) -> void:
	lock_control()
	show_control()

func show_control():
	if !fire.is_possessing:
		show()
	else:
		hide()

func lock_control():
	if fire.is_frenzy_unlocked:
		%Frenzy_Bar.value = 0
		%Frenzy_Hotkey.show()
		%Frenzy_Lock.hide()
	if fire.is_minion_unlocked:
		%Summon_Bar.value = 0
		%Summon_Hotkey.show()
		%Summon_Lock.hide()
	if fire.is_dash_unlocked:
		%Dash_Bar.value = 0
		%Dash_Hotkey.show()
		%Dash_Lock.hide()
	if fire.fireball_unlocked:
		%Shoot_Bar.value = 0
		%Shoot_Hotkey.show()
		%Shoot_Lock.hide()
		
		
func frenzy_activated():
	var tween = create_tween()
	tween.tween_property(%Frenzy_Bar, "value", 100, fire.frenzy_duration)
	tween.tween_property(%Frenzy_Bar, "value", 0, fire.frenzy_cooldown_time)
	
func minion_activated():
	var tween = create_tween()
	tween.tween_callback(set_bar_to_full.bind(%Summon_Bar))
	tween.tween_property(%Summon_Bar, "value", 0, fire.minion_cooldown_time)
	
func dash_activated():
	var tween = create_tween()
	tween.tween_callback(set_bar_to_full.bind(%Dash_Bar))
	tween.tween_property(%Dash_Bar, "value", 0, fire.dash_cooldown_time)
	
func shoot_activated():
	var tween = create_tween()
	tween.tween_callback(set_bar_to_full.bind(%Shoot_Bar))
	tween.tween_property(%Shoot_Bar, "value", 0, fire.shoot_cooldown_time)

func set_bar_to_full(bar):
	bar.value = 100
