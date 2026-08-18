extends Control

@onready var button_send = $"../osc/button_send"



func _ready() -> void:
	pass 
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	button_send.osc_address = "/button1"
	button_send.send_message([])
