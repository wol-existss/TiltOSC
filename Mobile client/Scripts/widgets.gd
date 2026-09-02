extends Control

# OSC messengers for each widget
@export var trigger: Node
@export var cluster: Node
@export var auxiliary: Node
@export var leftstick: Node
@export var rightstick: Node

var up = [0.0]
var down = [1.0]

func _ready() -> void:
	LoadNetworkConfig.load_network_conf($"../OSC/OSCClient")

func _process(delta: float) -> void:
	# Left stick inputs
	var left_input = Input.get_vector("lstick_left", "lstick_right", "lstick_up", "lstick_down") # Reads left stick analogue outputs clamped to +-1.0
	leftstick.send_message([left_input.x, left_input.y]) # Sends X and Y values for left stick
	
	# Right stick
	var right_input = Input.get_vector("rstick_left", "rstick_right", "rstick_up", "rstick_down") # Reads left stick analogue outputs clamped to +-1.0
	rightstick.send_message([right_input.x, right_input.y]) # Sends X and Y values for rright stick


# Settings menu
func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Preferences.tscn")


'''
OSC syntax examples for quick reference

<NodeName>.send_message(<Message>)

<NodeName>.osc_address = "<Address>"
'''


'''
Controller layout widgets
'''


## Triggers

# LT up/down
func _on_lt_button_down() -> void:
	trigger.osc_address = "/lt"
	trigger.send_message(down)
func _on_lt_button_up() -> void:
	trigger.osc_address = "/lt"
	trigger.send_message(up)

# RT up/down
func _on_rt_button_down() -> void:
	trigger.osc_address = "/rt"
	trigger.send_message(down)
	print("RT down")

func _on_rt_button_up() -> void:
	trigger.osc_address = "/rt"
	trigger.send_message(up)
	print("RT up")


# LB up/down
func _on_lb_button_down() -> void:
	trigger.osc_address = "/lb"
	trigger.send_message(down)

func _on_lb_button_up() -> void:
	trigger.osc_address = "/lb"
	trigger.send_message(up)


# RB up/down
func _on_rb_button_down() -> void:
	trigger.osc_address = "/rb"
	trigger.send_message(down)

func _on_rb_button_up() -> void:
	trigger.osc_address = "/rb"
	trigger.send_message(up)


## Button Cluster

# Y up/down
func _on_y_button_down() -> void:
	cluster.osc_address = "/y_button"
	cluster.send_message(down)

func _on_y_button_up() -> void:
	cluster.osc_address = "/y_button"
	cluster.send_message(up)


# X up/down
func _on_x_button_down() -> void:
	cluster.osc_address = "/x_button"
	cluster.send_message(down)

func _on_x_button_up() -> void:
	cluster.osc_address = "/x_button"
	cluster.send_message(up)


# B up/down
func _on_b_button_down() -> void:
	cluster.osc_address = "/b_button"
	cluster.send_message(down)

func _on_b_button_up() -> void:
	cluster.osc_address = "/b_button"
	cluster.send_message(up)


# A up/down
func _on_a_button_down() -> void:
	cluster.osc_address = "/a_button"
	cluster.send_message(down)

func _on_a_button_up() -> void:
	cluster.osc_address = "/a_button"
	cluster.send_message(up)


## D Pad

# UP button up/down
func _on_up_button_down() -> void:
	auxiliary.osc_address = "/up_button"
	auxiliary.send_message(down)

func _on_up_button_up() -> void:
	auxiliary.osc_address = "/up_button"
	auxiliary.send_message(up)


# DOWN button up/down
func _on_down_button_down() -> void:
	auxiliary.osc_address = "/down_button"
	auxiliary.send_message(down)

func _on_down_button_up() -> void:
	auxiliary.osc_address = "/down_button"
	auxiliary.send_message(up)


# LEFT button up/down
func _on_left_button_down() -> void:
	auxiliary.osc_address = "/left_button"
	auxiliary.send_message(down)

func _on_left_button_up() -> void:
	auxiliary.osc_address = "/left_button"
	auxiliary.send_message(up)


# RIGHT button up/down
func _on_right_button_down() -> void:
	auxiliary.osc_address = "/right_button"
	auxiliary.send_message(down)

func _on_right_button_up() -> void:
	auxiliary.osc_address = "/right_button"
	auxiliary.send_message(up)


## Auxiliary

# Back button up/down
func _on_back_button_down() -> void:
	auxiliary.osc_address = "/back"
	auxiliary.send_message(down)

func _on_back_button_up() -> void:
	auxiliary.osc_address = "/back"
	auxiliary.send_message(up)


# Guide button up/down
func _on_guide_button_down() -> void:
	auxiliary.osc_address = "/guide"
	auxiliary.send_message(down)

func _on_guide_button_up() -> void:
	auxiliary.osc_address = "/guide"
	auxiliary.send_message(up)


# Start button up/down
func _on_start_button_down() -> void:
	auxiliary.osc_address = "/start"
	auxiliary.send_message(down)

func _on_start_button_up() -> void:
	auxiliary.osc_address = "/start"
	auxiliary.send_message(up)


# Quick calibration
func _on_quick_calib_pressed() -> void:
	auxiliary.osc_address = "/landscape"
	auxiliary.send_message([])
