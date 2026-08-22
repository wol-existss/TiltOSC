extends Node
# Debug
@export var debug_output = false
@export var debug_output_buffer = 100
var frames = 0

# Temporary
@onready var osc_send = $"../calib"

# OSC sender nodes
@export var gravity: Node
@export var gyro: Node

#func _ready() -> void:
#	pass

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

func _on_preferences_pressed() -> void:
	get_tree().change_scene_to_file("res://Preferences.tscn")

func _on_landscape_pressed() -> void:
	osc_send.osc_address = "/landscape"
	osc_send.send_message([])
	
func _on_cw_pressed() -> void:
	osc_send.osc_address = "/cw"
	osc_send.send_message([])
