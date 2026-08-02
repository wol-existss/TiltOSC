extends Node
@export var debug_output = true
@export var debug_output_buffer = 60
var frames = 0
var wheel_angle = 0
var pitch_angle = 0

@onready var wheel_message = $"../WheelMessage"
@onready var pitch_message = $"../PitchMessage"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var g = Input.get_gravity() # Gets graavity data

	wheel_angle = wrapf((atan2(g.y, g.x) / PI) + 0.5, -1.0, 1.0) # Severe crosstalk! needs fixing.
	pitch_angle = wrapf((atan2(g.y, g.z) / PI) + 0.5, -1.0, 1.0)
	
	wheel_message.send_message(wheel_angle)
	pitch_message.send_message(pitch_angle)
	
	frames = frames + 1 # Adds one frame for debug buffering
	if frames >= debug_output_buffer and debug_output:
		print(g)
		print(wheel_angle)
		print(pitch_angle)
		frames = 0
