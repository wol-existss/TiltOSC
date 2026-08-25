extends Node
@onready var widget_canvas = $"../WidgetCanvas"

# Widget scenes
@export var button_scene: PackedScene

# Debug
@export var master_debug = false
@export var widget_debug = true

var widgets = [] # Widget array

func _ready() -> void:
	var new_id = add_widget("button")
	if widget_debug:
		print("Addded widget with ID:", new_id)
		print("Current widgets: ", widgets)
		print("After removal: ", widgets)

func _process(delta: float) -> void:
	pass

# Widget add function
func add_widget(type: String) -> int:
	var new_id = widgets.size() ## Creates new ID based off of the number of entries in the array
	var widget = {"id": new_id, "type": type, "value": 0.0} ## Forms dictionary
	widgets.append(widget) ## Adds entry to end of array
	
	
	
	# Add button
	if type == "button":
		var new_button = button_scene.instantiate()
		widget_canvas.add_child(new_button)
		new_button.position = Vector2(50, 50)
	
	return new_id

# Widget remove function
func remove_widget(id: int) -> void:
	for i in range(widgets.size()):
		if widgets[i]["id"] == id:
			widgets.remove_at(i)
			return
