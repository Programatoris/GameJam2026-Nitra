extends Node


#================================================================================
# Variables
@onready var pause_menu: Control = $PauseMenu


#================================================================================
# Functions
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if pause_menu.get_node("OptionsMenu").visible == true:
			pause_menu.get_node("OptionsMenu").visible = false
			pause_menu.get_node("MainMenu").visible = true
		else:
			if pause_menu.visible == true:
				get_tree().paused = false
			else:
				get_tree().paused = true
			
			pause_menu.visible = not pause_menu.visible
