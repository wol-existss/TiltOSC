extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_id = IdManager.get_new_id()
	print(my_id)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
