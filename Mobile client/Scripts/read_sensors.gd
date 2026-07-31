extends Node
var frames = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var g = Input.get_gravity()
	frames = frames + 1
	if frames >= 60:
		print(Input.get_accelerometer())
		frames = 0
