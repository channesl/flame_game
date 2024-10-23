extends Node2D

@onready var root : PackedScene = preload("res://scenes/root.tscn")

@export var time_before_roots : float
@export var time_between_roots : float
@export var magic_tree : StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	magic_tree.enters_boss_room.connect(entered_boss_room)
	%Start_Timer.wait_time = time_before_roots
	%Root_Timer.wait_time = time_between_roots


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func entered_boss_room():
	print("Start")
	%Start_Timer.start()

func _on_start_timer_timeout() -> void:
	%Root_Timer.start()
	spawn_roots()

func _on_root_timer_timeout() -> void:
	spawn_roots()

func spawn_roots():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var rand = random.randi_range(1, 4)
	var root_positions = get_root_positions(rand)
	
	for position in root_positions:
		var new_root_scene = root.instantiate()
		%Roots.call_deferred("add_child", new_root_scene)
		new_root_scene.position = position

func get_root_positions(position_set_number) -> Array:
	var positions_array = []
	match position_set_number:
		1: 
			for i in 10:
				positions_array.append(Vector2((((16*5) - 8) - (i*16)), ((16*4) - 8)))
				positions_array.append(Vector2((((16*5) - 8) - (i*16)), -((16*4) - 8)))
				if i <= 6:
					positions_array.append(Vector2(((16*5) - 8), (((16*3) - 8) - (i*16))))
					positions_array.append(Vector2(-((16*5) - 8), (((16*3) - 8) - (i*16))))
		2: 
			for x in 4:
				for y in 12:
					positions_array.append(Vector2((8 + (2*(x+1)*16)), ((16*6) - 8) - (y*16)))
		3: 
			for x in 4:
				for y in 12:
					positions_array.append(Vector2((-8 - (2*(x+1)*16)), ((16*6) - 8) - (y*16)))
		4: 
			for x in 8:
				for y in 6:
					positions_array.append(Vector2((-(18*8) + (2*(x+1)*16)), ((16*6) - 8) - (2*y*16)))
	return positions_array
