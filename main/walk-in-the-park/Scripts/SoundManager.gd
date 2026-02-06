extends Node


#================================================================================
# Variables
var effects_nodes = getRoot().get_nodes_in_group("Effects")
var music_nodes = getRoot().get_nodes_in_group("Music")


#================================================================================
# Functions
func _ready() -> void:
	print(music_nodes)
	print(effects_nodes)


@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass


func musicGroup(_percent: int) -> void:
	var volume_db = convertPercentToDecibels(_percent)
	
	for node in get_tree().get_nodes_in_group("Music"):
		if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
			node.volume_db = volume_db


func effectsGroups(_percent: int) -> void:
	var volume_db = convertPercentToDecibels(_percent)
	
	for node in get_tree().get_nodes_in_group("Effects"):
		if node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D:
			node.volume_db = volume_db


#==================================================
# Helper functions
func getRoot() -> MainLoop:
	return Engine.get_main_loop()


func convertPercentToDecibels(_percent) -> int:
	var percent = clamp(_percent, 0, 100)
	return lerp(-80, 0, percent / 100.0)
