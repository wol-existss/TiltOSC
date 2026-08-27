extends Node
#@onready var widget_canvas = $"../WidgetCanvas"
'''
# Widget scenes
@export var button_scene: PackedScene

# Debug
@export var master_debug = false # Enables all debug flags if enabled
@export var widget_debug = true
@export var save_load_debug = true

var widgets = [] # Widget array

func _ready() -> void:
	var new_id = add_widget("button")
	
	# Debug
	if master_debug:
		widget_debug = true
		save_load_debug = true
	
	if widget_debug:
		print("Addded widget with ID:", new_id)
		print("Current widgets: ", widgets)
		print("After removal: ", widgets)

func _process(delta: float) -> void:
	pass
'''

'''
# Widget add function
func add_widget(type: String) -> int:
	var new_id = widgets.size() ## Creates new ID based off of the number of entries in the array
	var widget = {"id": new_id, "type": type, "value": 0.0} ## Forms dictionary
	widgets.append(widget) ## Adds entry to end of array
	
	# Add button
	if type == "button":
		pass
		var new_button = button_scene.instantiate()
		widget_canvas.add_child(new_button)
		new_button.position = Vector2(widget["x"], widget["y"])
	
	return new_id
'''

'''
# Widget remove function
func remove_widget(id: int) -> void:
	for i in range(widgets.size()):
		if widgets[i]["id"] == id:
			widgets.remove_at(i)
			return
'''
'''
# Save widgets
func save_widgets() -> void:
	var json_string = JSON.stringify(widgets) # Converts array into JSON
	var file = FileAccess.open("user://widgets.json", FileAccess.WRITE) # Create or open the existing JSON file for writing.
	file.store_string(json_string) # Push modifications
	if save_load_debug:
		print("Widgets saved")
'''
'''
# Load widgets
func load_widgets() -> void:
	var file = FileAccess.open("user://widgets.json", FileAccess.READ) # Open saved file for reading
	var json_string = file.get_as_text() # Extract the raw text
	widgets = JSON.parse_string(json_string) # Converts the raw text back into array of dictionaries
	if save_load_debug:
		print("Widgets loaded")
'''
# Temporary
func _on_b_button_down() -> void:
	print("b button down")

func _on_b_button_up() -> void:
	print("b button up")

func _on_a_button_down() -> void:
	print("a button down")

func _on_a_button_up() -> void:
	print("a button up")
