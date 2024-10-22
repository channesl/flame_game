extends Control

@export var lumberjack : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lumberjack.rage_activated.connect(rage_activated)
	lumberjack.chop_activated.connect(chop_activated)

func _physics_process(delta: float) -> void:
	lock_control()
	show_control()
	
func show_control():
	if lumberjack.is_possessed:
		show()
	else:
		hide()

func lock_control():
	if lumberjack.is_rage_unlocked:
		%Rage_Bar.value = 0
		%Rage_Hotkey.show()
		%Rage_Lock.hide()
		
func rage_activated():
	var tween = create_tween()
	tween.tween_property(%Rage_Bar, "value", 100, lumberjack.rage_duration)
	tween.tween_property(%Rage_Bar, "value", 0, lumberjack.rage_cooldown_time)
	
func chop_activated():
	var tween = create_tween()
	tween.tween_callback(set_bar_to_full.bind(%Chop_Bar))
	tween.tween_property(%Chop_Bar, "value", 0, lumberjack.chop_cooldown_time)
	
func set_bar_to_full(bar):
	bar.value = 100
