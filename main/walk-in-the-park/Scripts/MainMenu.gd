extends Control


#==================================================
# Functions
func _ready() -> void:
	print(Time.get_unix_time_from_datetime_string(Time.get_date_string_from_system()))


func _on_start_button_pressed() -> void:
	print("Start")


func _on_options_button_pressed() -> void:
	print("Options")


func _on_credits_pressed() -> void:
	print("Credits")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
