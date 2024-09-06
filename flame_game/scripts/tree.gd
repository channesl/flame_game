extends StaticBody2D


@onready var label : Label = $Label

var text_percent_visible : float = 0.0
var text_length : int = 15
var player_in_area : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible_ratio = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Entered tree zone")
	player_in_area = true
	$Label/Timer.start()


func _on_area_2d_body_exited(body: Node2D) -> void:
	player_in_area = false
	$Label/Timer.start()
 

func _on_timer_timeout() -> void:
	if player_in_area == true:
		label.visible_ratio += 1.0/15.0
		if label.visible_ratio >= 1:
			$Label/Timer.stop()
	else:
		label.visible_ratio -= 1.0/15.0
		if label.visible_ratio <= 0:
			$Label/Timer.stop()
			
			
			
			
			
			
			
			
			
			
			
			
