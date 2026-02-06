extends Node2D

@onready var area: Area2D = $Area2D
var triggered := false

func _ready() -> void:
	add_to_group("enemies")
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if triggered:
		return

	if body.is_in_group("player"):
		triggered = true
		
		# Call player's death function
		if body.has_method("die"):
			body.die()
		
		# Restart level after 3 seconds
		reset_level()

func reset_level() -> void:
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
