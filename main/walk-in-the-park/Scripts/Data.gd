extends Node


#==================================================
# Constants
const SAVE_PATH: String = "res://Saves/SAVE.json"


#==================================================
# Variables
var level_count: int = 5
var level_data_preset: Dictionary = {
	"level": 1,
	"attemps": 0,
	"time": "00:00:000"
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
		"UI_Scale": 1
	}
}


#==================================================
# Functions
func _ready() -> void:
	levelDataFiller()
	loadData()


func levelDataFiller():
	for i in level_count:
		level_data_preset["level"] = i
		data["level_data"].append(level_data_preset)


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
