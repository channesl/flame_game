extends TextureProgressBar

@onready var parent = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if "max_health" in parent:
		max_value = parent.max_health
	else:
		max_value = parent.maxHealth
	hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = parent.current_health
	if value != max_value:
		show()
