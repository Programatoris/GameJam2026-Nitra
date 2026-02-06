extends Control


#================================================================================
# Variables
var map_selector: Node = null

#================================================================================
# Functions
func _ready() -> void:
	#print(Time.get_unix_time_from_datetime_string(Time.get_date_string_from_system()))
	pass


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if $OptionsMenu.visible == true:
			$OptionsMenu.visible = false
			$MainMenu.visible = true


func _on_start_button_pressed() -> void:
	var map_selector_scene = preload("res://Scenes/LevelSelector.tscn")
	map_selector = map_selector_scene.instantiate()
	
	$MainMenu.visible = false
	get_tree().current_scene.add_child(map_selector)


func _on_options_button_pressed() -> void:
	$OptionsMenu.visible = true
	$MainMenu.visible = false


func _on_credits_pressed() -> void:
	print("Credits")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(_value: float) -> void:
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(_value, _value)


#==================================================
# Helper functions
func returnedToMainMenu() -> void:
	map_selector.queue_free()
	map_selector = null
	$MainMenu.visible = true
