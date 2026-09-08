extends Node

# Debug
@export var debug_output = false
@export var debug_output_buffer = 100

# OSC sender nodes
@export var gravity: Node
@export var gyro: Node
@export var init: Node
var frames = 0

var ipv4 = IP.get_local_addresses()

func _ready() -> void:
	LoadNetworkConfig.load_network_conf($"../OSC/OSCClient")
	 
	init.send_message(["connected"])
	init.send_message(ipv4)

func _process(delta: float) -> void:
	var g = Input.get_gravity()
	var gy = Input.get_gyroscope()
	
	gravity.send_message([g.x, g.y, g.z])
	gyro.send_message([gy.x, gy.y, gy.z])
	
	# Debug output
	frames = frames + 1
	if frames >= debug_output_buffer and debug_output:
		print(g, gy)
		frames = 0
