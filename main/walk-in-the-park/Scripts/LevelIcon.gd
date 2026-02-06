extends Node


#================================================================================
# Constants
const LEVELS_PATH: String = "res://Scenes/Maps/"


#================================================================================
# Variables
var level_data: Dictionary


#================================================================================
# Functions
func _ready() -> void:
	for data in Data.data["level_data"]:
		if data["level"] == int(name):
			level_data = data
			var temp: Node = get_child(0)
			temp.text = name
			break
	
	handleSignals()


func _process(delta: float) -> void:
	pass


func handleSignals() -> void:
	var temp: Node = get_child(0)
	temp.pressed.connect(on_button_pressed)


func on_button_pressed() -> void:
	pass
