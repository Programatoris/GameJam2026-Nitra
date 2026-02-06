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
		
		visible = false
	
		area.set_deferred("monitoring", false)
		queue_free()
