extends Node
var next_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_new_id() -> int:
	var assigned_id = next_id
	next_id += 1
	return assigned_id
