extends Node


#================================================================================
# Variables
var effects_nodes: Array[Node]
var music_nodes: Array[Node]


#================================================================================
# Functions
func musicGroup() -> void:
	var volume_db = convertPercentToDecibels(Data.data["settings"]["Music"])
	
	for node in get_tree().get_nodes_in_group("Music"):
		if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
			if Data.data["settings"]["Music"] == 0.0:
				node.stream_paused = true
			else:
				node.stream_paused = false
				node.volume_db = volume_db


func effectsGroups() -> void:
	var volume_db = convertPercentToDecibels(Data.data["settings"]["Effects"])
	
	for node in get_tree().get_nodes_in_group("Effects"):
		if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
			if Data.data["settings"]["Effects"] == 0.0:
				node.stream_paused = true
			else:
				node.stream_paused = false
				node.volume_db = volume_db


#==================================================
# Helper functions
func convertPercentToDecibels(_percent) -> int:
	var percent = clamp(_percent, 0, 100)
	return lerp(-15, 0, percent / 100.0)
