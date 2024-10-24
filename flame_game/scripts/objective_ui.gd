extends Control

@export var current_objective : int = 0

var progress : int = 0
var progress_goal : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_objective()

func update_objective():
	match current_objective:
		# Get 4 Magic Logs
		0:
			%Magic_Log.show()
			progress_goal = 4
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
		# Enter Mother Tree
		1:
			%Magic_Log.hide()
			%Open_Tree.show()
			%Progress.text = "ENTER MOTHER TREE"
		# Kill 4 roots
		2:
			%Open_Tree.hide()
			%Root.show()
			progress_goal = 4
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
		# Damage heart
		3:
			%Root.hide()
			%Heart.show()
			progress_goal = 2
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
		# Kill 8 roots
		4:
			%Heart.hide()
			%Root.show()
			progress_goal = 8
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
		# Damage heart
		5:
			%Root.hide()
			%Heart.show()
			progress_goal = 2
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
		# Kill 10 roots
		6:
			%Heart.hide()
			%Root.show()
			progress_goal = 10
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
		# Damage heart
		7:
			%Root.hide()
			%Heart.show()
			progress_goal = 2
			%Progress.text = str(progress) + "/" + str(progress_goal)
			if progress >= progress_goal:
				current_objective += 1
				progress = 0
