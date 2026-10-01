extends Node
# Debug
@export var debug_output = false
@export var debug_output_buffer = 100

# OSC sender nodes
@export var gravity: Node
@export var gyro: Node
var frames = 0

# Load network configuration
func _ready() -> void:
	LoadNetworkConfig.load_network_conf($"../OSC/OSCClient") 

func _process(delta: float) -> void:
	var g = Input.get_gravity()
	var gy = Input.get_gyroscope()
	# The rate at which updates are sent is dictated by the frame rate, which is wholly independant of this script
	gravity.send_message([g.x, g.y, g.z])
	gyro.send_message([gy.x, gy.y, gy.z])
	
	# Debug output
	frames = frames + 1
	if frames >= debug_output_buffer and debug_output:
		print(g, gy)
		frames = 0
