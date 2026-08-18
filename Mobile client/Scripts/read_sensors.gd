extends Node
# Debug
@export var debug_output = false
@export var debug_output_buffer = 100
var frames = 0

# OSC sender nodes
@export var gravity: Node
@export var gyro: Node

#func _ready() -> void:
#	pass

func _process(delta: float) -> void:
	var g = Input.get_gravity()
	var gy = Input.get_gyroscope()
	
	# gravity.send_message([g.x, g.y, g.z])
	# gyro.send_message([gy.x, gy.y, gy.z])
	
	frames = frames + 1
	if frames >= debug_output_buffer and debug_output:
		print(g, gy)
		frames = 0
