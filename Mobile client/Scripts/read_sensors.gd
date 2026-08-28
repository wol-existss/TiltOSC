extends Node
# Debug
@export var debug_output = false
@export var debug_output_buffer = 100
@export var no_sensor_send = false

# OSC sender nodes
@export var gravity: Node
@export var gyro: Node
var frames = 0

func _ready() -> void:
	LoadNetworkConfig.load_network_conf($OSC/OSCClient) 

func _process(delta: float) -> void:
	var g = Input.get_gravity()
	var gy = Input.get_gyroscope()
	
	if not no_sensor_send:
		gravity.send_message([g.x, g.y, g.z])
		gyro.send_message([gy.x, gy.y, gy.z])
	
	# Debug output
	frames = frames + 1
	if frames >= debug_output_buffer and debug_output:
		print(g, gy)
		frames = 0
