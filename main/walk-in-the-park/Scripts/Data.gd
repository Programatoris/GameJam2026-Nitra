extends Node


#================================================================================
# Constants
const SAVE_PATH: String = "res://Saves/SAVE.json"


#================================================================================
# Variables
var level_count: int = 10
var level_data_preset: Dictionary = {
	"level": 0,
	"attemps": 0,
	"time": "00:00:000",
	"passed_levels": 0
}
var data: Dictionary = {
	"player_data": {
		"health": 100,
		"coins": 0
	},
	"level_data": [
	],
	"settings": {
		"Music": 100,
		"Effects": 100,
		"UI_Scale": 1,
		"fullscreen": 0
	}
}


#================================================================================
# Functions
func _ready() -> void:
	levelDataFiller()
	loadData()


func saveData() -> void:
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file")
		return

	file.store_string(JSON.stringify(data))
	file.close()


func loadData() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file")
		return

	var data_as_string: String = file.get_as_text()
	file.close()

	var raw_data: Dictionary = JSON.parse_string(data_as_string)
	if not raw_data.is_empty():
		data = raw_data


#==================================================
# Helper functions
func levelDataFiller() -> void:
	data["level_data"] = []

	for i in range(level_count):
		var level_entry := level_data_preset.duplicate(true)
		level_entry["level"] = i + 1

		data["level_data"].append(level_entry)
