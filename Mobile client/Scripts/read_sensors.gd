extends Node
@export var debug_output = true
var frames = 0
var wheel_angle = 0
var pitch_angle = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var g = Input.get_gravity()
	frames = frames + 1
	wheel_angle = wrapf((atan2(g.y, g.x) / PI) + 0.5, -1.0, 1.0)
	pitch_angle = wrapf((atan2(g.y, g.z) / PI) + 0.5, -1.0, 1.0)

	if frames >= 10 and debug_output:
		print(g)
		print(wheel_angle)
		print(pitch_angle)
		frames = 0
