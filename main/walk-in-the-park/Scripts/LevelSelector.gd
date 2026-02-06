extends Node


#================================================================================
# Variables
const MAX_H_LEVEL: int = 5
const MAX_V_LEVEL: int = 2
const OFSET_H: int = 225
const OFSET_V: int = 225
const LEVEL_ICON: PackedScene = preload("res://Nodes/LevelIcon.tscn")


#================================================================================
# Functions
func _ready() -> void:
	var counter: int = 0
	
	for i in range(MAX_V_LEVEL):
		for j in range(MAX_H_LEVEL):
			counter += 1
			var icon := LEVEL_ICON.instantiate()
			icon.position = Vector2(325 * j + OFSET_H, i * 400 + OFSET_V)
			icon.name = str(counter)
			add_child(icon)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().root.get_node("Main").get_node("MainMenu").returnedToMainMenu()


func _on_reset_level_button_pressed() -> void:
	Data.levelDataFiller()
	Data.saveData()
	get_tree().reload_current_scene()
