extends Node2D

@onready var tree : PackedScene = preload("res://scenes/tree.tscn")
@onready var noise_generator : NoiseGenerator = %NoiseGenerator
@export var tree_noise_texture : NoiseTexture2D

var noise : Noise
var tree_noise : Noise
var width : int
var height : int 
	
func _ready() -> void:
	generate_trees()

func generate_trees():
	noise = noise_generator.settings.noise
	tree_noise = tree_noise_texture.noise
	width = noise_generator.settings.world_size.x
	height = noise_generator.settings.world_size.y
	
	var noise_val
	var tree_noise_val
	
	for x in range(1, width-1):
		for y in range(1, height-1):
			noise_val = noise.get_noise_2d(x,y)
			tree_noise_val = tree_noise.get_noise_2d(x,y)
			
			if (tree_noise_val > 0.95) and (noise_val > -0.2):
				var tree_instance = tree.instantiate()
				add_child(tree_instance)
				tree_instance.position = Vector2i(x*16, y*16)
