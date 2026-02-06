extends AnimatedSprite2D

# Path to the next level scene
@export var next_level_path: String = "res://Scenes/Maps/level2.tscn"

func _ready() -> void:
	# Connect to Area2D body_entered signal
	# Make sure you have an Area2D as a child of this node
	var area = get_node("Area2D")
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body.is_in_group("player"):  # Make sure your player is in the "player" group
		change_scene()

func change_scene() -> void:
	get_tree().change_scene_to_file(next_level_path)
