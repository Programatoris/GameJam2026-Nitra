extends Node


#==================================================
# Constants
const SAVE_PATH: String = "res://Saves/SAVE.json"


#==================================================
# Variables
var player_data: Dictionary = {
	"health": 100,
	"coins": 0
}
var level_data: Array[Dictionary] = [
	{
		"attemps": 0,
		"time": "00:00:000"
	},
	{
		"attemps": 0,
		"time": "00:00:000"
	},
	{
		"attemps": 0,
		"time": "00:00:000"
	}
]


#==================================================
# Functions
func savePlayerData() -> void:
	var save_dict := {
		"player_data": player_data,
		"level_data": level_data
	}

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file")
		return

	file.store_string(JSON.stringify(save_dict))
	file.close()


func loadPlayerData() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")
		return

	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("Failed to open save file")
		return

	var content: String = file.get_as_text()
	file.close()

	var data: Dictionary = JSON.parse_string(content)
	if data.is_empty():
		push_error("Invalid or empty save data")
		return

	if data.has("player_data"):
		player_data = data["player_data"]

	if data.has("level_data"):
		level_data = data["level_data"]
