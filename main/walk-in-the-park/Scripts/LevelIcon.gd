extends Node


#================================================================================
# Constants
const LEVELS_PATH: String = "res://Scenes/Maps/Level"
var level_path: String = ""
var level: Node

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
	level_path = LEVELS_PATH + str(int(level_data["level"])) + ".tscn"
	
	if not FileAccess.file_exists(level_path):
		return
	
	#level = load(level_path).instantiate()
	#var parent = get_parent()
	#parent.visible = false
	#add_child(level)
	get_tree().change_scene_to_file(level_path)
	#get_tree().root.get_node("Main").add_child(level)
	#get_tree().current_scene.add_child(level)
