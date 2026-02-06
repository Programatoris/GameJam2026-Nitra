extends Control


#================================================================================
# Variables
var map_selector: Node = null


#================================================================================
# Functions
func _ready() -> void:
	#print(Time.get_unix_time_from_datetime_string(Time.get_date_string_from_system()))
	dontPause()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and name == "PauseMenu":
		if $OptionsMenu.visible == true:
			$OptionsMenu.visible = false
			$MainMenu.visible = true
		else:
			visible = not visible
			get_tree().paused = not get_tree().paused
	elif Input.is_action_just_pressed("ui_cancel"):
		if $OptionsMenu.visible == true:
			$OptionsMenu.visible = false
			$MainMenu.visible = true


# UI will be running even if all is paused
func dontPause() -> void:
	for node in get_tree().get_nodes_in_group("Effects"):
		node.process_mode = Node.PROCESS_MODE_ALWAYS
	
	for node in get_tree().get_nodes_in_group("Music"):
		node.process_mode = Node.PROCESS_MODE_ALWAYS
	
	for node in get_tree().get_nodes_in_group("UI"):
		node.process_mode = Node.PROCESS_MODE_ALWAYS


func _on_start_button_pressed() -> void:
	var map_selector_scene = preload("res://Scenes/LevelSelector.tscn")
	map_selector = map_selector_scene.instantiate()
	
	$MainMenu.visible = false
	get_tree().current_scene.add_child(map_selector)
	dontPause()


func _on_options_button_pressed() -> void:
	$OptionsMenu.visible = true
	$MainMenu.visible = false


func _on_credits_pressed() -> void:
	print("Credits")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	var window: bool = DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if window else DisplayServer.WINDOW_MODE_WINDOWED)
	
	
func _on_unpause_button_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_back_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_h_slider_value_changed(_value: float) -> void:
	await get_tree().create_timer(0.1).timeout
	scale = Vector2(_value, _value)


#==================================================
# Helper functions
func returnedToMainMenu() -> void:
	map_selector.queue_free()
	map_selector = null
	$MainMenu.visible = true
