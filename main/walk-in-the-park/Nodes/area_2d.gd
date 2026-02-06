extends Area2D

@export var speed = 300.0

func _process(delta):
	# Ostne padajú smerom nadol
	position.y += speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("die"):
			body.die()
		queue_free() # Odstráni osteň po zásahu
	
	# Odstráni osteň, ak trafí podlahu (TileMap)
	if body is TileMap:
		queue_free()
