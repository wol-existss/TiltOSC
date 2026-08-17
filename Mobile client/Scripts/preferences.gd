extends Control

# debug variables
@export var debug = false
@export var output_buffer_max = 100
var output_buffer = 0

"""
Onreadies for all buttons and OSC outputs
"""

# Polling rate configuration buttons
@onready var button_30hz = $"ScrollContainer/MarginContainer/VBoxContainer/pollling rate/30 Hz"
@onready var button_60hz = $"ScrollContainer/MarginContainer/VBoxContainer/pollling rate/60 Hz"
@onready var button_90hz = $"ScrollContainer/MarginContainer/VBoxContainer/pollling rate/90 Hz"
@onready var button_120hz = $"ScrollContainer/MarginContainer/VBoxContainer/pollling rate/120 Hz"
@onready var button_unlimited = $"ScrollContainer/MarginContainer/VBoxContainer/pollling rate/Unlimited"

# V-Sync button
@onready var vsync_button = $ScrollContainer/MarginContainer/VBoxContainer/VSync

# Calibration buttons
@onready var landscape = $OSC/landscape
@onready var cw = $OSC/cw
@onready var osc_send = $OSC/osc_send

# Settings variables
var current_vsync_mode = true
var current_polling_rate = 60
var last_exit_clean = true

# Load the current configuration if it exists, or insert placeholders if otherwise.
func _ready() -> void:
	# Configuration creation, loading, and saving.
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	var saved_rate = config.get_value("settings", "polling_rate", 60)
	var saved_vsync = config.get_value("settings", "vsync", true)
	
	# Updates V-Sync button status to reflect config
	current_vsync_mode = saved_vsync
	if saved_vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	vsync_button.button_pressed = saved_vsync
	
	# Updates polling rate buttons to reflect config systemically.
	var polling_buttons = [button_30hz, button_60hz, button_90hz, button_120hz, button_unlimited]
	current_polling_rate = saved_rate
	for button in polling_buttons:
		if button.get_meta("polling_rate") == saved_rate:
			button.set_pressed(true)
	
	# Did the last session exit cleanly?
	last_exit_clean = config.get_value("settings", "clean_exit", true)
	if not last_exit_clean:
		print("The previous session did not exit cleanly!")
	
	# updates configuration for last 
	config.set_value("settings", "clean_exit", false)
	config.save("user://settings.cfg")

# Output logs if debug is enabled.
func _process(delta: float) -> void:
	if debug:
		output_buffer += 1
		if output_buffer >= output_buffer_max:
			print(current_polling_rate)
			output_buffer = 0
			print(Engine.get_frames_per_second())

# Save the polling rate
func _save_polling_rate(rate: int) -> void:
	var config = ConfigFile.new()
	config.load("user://settings.cfg") 
	config.set_value("settings", "polling_rate", rate) 
	config.save("user://settings.cfg")
	current_polling_rate = rate

# Save V-Sync mode
func _save_vsync_mode(vsync: bool) -> void:
	if vsync:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	
	# Save configuration
	var config = ConfigFile.new()
	config.load("user://settings.cfg") 
	config.set_value("settings", "vsync", vsync) 
	config.save("user://settings.cfg")
	current_vsync_mode = vsync

# Polling rate buttons
func _on_30Hz() -> void:
	_save_polling_rate(30)
func _on_60Hz() -> void:
	_save_polling_rate(60)
func _on_90Hz() -> void:
	_save_polling_rate(90)
func _on_120Hz() -> void:
	_save_polling_rate(120)
func _on_unlimited_hz() -> void:
	_save_polling_rate(0)

# V-Sync toggle button.
func _on_v_sync_toggled(toggled_on: bool) -> void:
	_save_vsync_mode(toggled_on)

# Calibration buttons
func _on_landscape_pressed() -> void:
	osc_send.osc_address = "/landscape"
	osc_send.send_message([])

func _on_clockwise_pressed() -> void:
	osc_send.osc_address = "/cw"
	osc_send.send_message([])


# Kill button. Triggers "did not exit cleanly!" boot flag.
func _on_kill() -> void:
	get_tree().quit() 
