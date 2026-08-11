extends Control

# debug variables
@export var debug = false
@export var output_buffer_max = 100
var output_buffer = 0

# Onreadies for... all of the buttons I guess?

# vsync button
@onready var vsync_button = $MarginContainer/VBoxContainer/VSync

# Polling rate configuration buttons
@onready var button_30hz = $"MarginContainer/VBoxContainer/BoxContainer/30 Hz"
@onready var button_60hz = $"MarginContainer/VBoxContainer/BoxContainer/60 Hz"
@onready var button_90hz = $"MarginContainer/VBoxContainer/BoxContainer/90 Hz"
@onready var button_120hz = $"MarginContainer/VBoxContainer/BoxContainer/120 Hz"
@onready var button_unlimited = $MarginContainer/VBoxContainer/BoxContainer/Unlimited

# Settings variables
var current_vsync_mode = true
var current_polling_rate: int = 60

# Load the current configuration if it exists, or insert placeholders if otherwise.
func _ready() -> void:
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
	
	# Updates polling rate buttons to reflect config
	var polling_buttons = [button_30hz, button_60hz, button_90hz, button_120hz, button_unlimited]
	current_polling_rate = saved_rate
	for button in polling_buttons:
		if button.get_meta("polling_rate") == saved_rate:
			button.set_pressed(true)

# Output logs if output buffer is ennabled.
func _process(delta: float) -> void:
	if debug:
		output_buffer += 1
		if output_buffer >= output_buffer_max:
			print(current_polling_rate)
			output_buffer = 0
			print(Engine.get_frames_per_second())

# Save the polling rrate
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

# V-Sync toggle button
func _on_v_sync_toggled(toggled_on: bool) -> void:
	_save_vsync_mode(toggled_on)
