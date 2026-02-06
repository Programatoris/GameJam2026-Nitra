extends AnimatedSprite2D

# Path template for levels
@export var level_path_template: String = "res://Scenes/Maps/Level{level}.tscn"

# State to track if the flag has already run away
var has_run_away: bool = false

func _ready() -> void:
	# Connect Area2D signal
	var area = get_node("Area2D")
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if not has_run_away:
			run_away()
		else:
			change_scene()

func run_away() -> void:
	has_run_away = true
	
	# Create a smooth sliding animation
	var tween = create_tween()
	# Smoothly move 400 pixels to the left over 0.5 seconds
	tween.tween_property(self, "position:x", position.x - 550, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y + 32, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	print("The flag escaped!")

func change_scene() -> void:
	var current_scene = get_tree().current_scene
	var current_scene_name = current_scene.name

	if not current_scene_name.match("Level*"):
		print("Current scene name '" + current_scene_name + "' does not match Level pattern")
		return
	
	var level_str = current_scene_name.replace("Level", "")
	var current_level = int(level_str)
	var next_level = current_level + 1

	var next_level_path = level_path_template.format({"level": next_level})

	if not FileAccess.file_exists(next_level_path):
		print("No next level found. Game completed!")
		return
	
	get_tree().change_scene_to_file(next_level_path)
