extends AnimatedSprite2D

# Path template for levels - using {level} as the placeholder
@export var level_path_template: String = "res://Scenes/Maps/Level{level}.tscn"

func _ready() -> void:
	# Connect Area2D signal
	var area = get_node("Area2D")
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_scene()

func change_scene() -> void:
	# Get the current scene root node
	var current_scene = get_tree().current_scene
	var current_scene_name = current_scene.name  # e.g., "Level1"

	# Check if the name starts with "Level" using a wildcard
	if not current_scene_name.match("Level*"):
		print("Current scene name '" + current_scene_name + "' does not start with 'Level'")
		return
	
	# Extract the number by removing the "Level" text
	var level_str = current_scene_name.replace("Level", "")
	var current_level = int(level_str)
	var next_level = current_level + 1

	# Build next level path
	# We pass the next_level number into the {level} placeholder
	var next_level_path = level_path_template.format({"level": next_level})

	# Check if the next level scene file actually exists on disk
	if not FileAccess.file_exists(next_level_path):
		print("No next level found at: " + next_level_path + ". Game completed!")
		return
	
	# Change to the next level
	var error = get_tree().change_scene_to_file(next_level_path)
	if error != OK:
		print("Error changing scene: ", error)
