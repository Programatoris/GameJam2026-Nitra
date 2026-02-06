extends Area2D

@export var speed = 300.0
var is_resetting = false # Prevents multiple reloads at once

func _process(delta):
	# Spikes fall down
	position.y += speed * delta
	
	# Optimization: Delete spike if it falls far off screen 
	# (Adjust 2000 to your level height)
	if position.y > 2000:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player") and not is_resetting:
		if body.has_method("die"):
			body.die()
			is_resetting = true # Lock this spike from calling reset again
			reset_level()

func reset_level() -> void:
	# Create the timer on the SceneTree itself, not the spike node.
	# This way, even if the spike is deleted, the timer continues.
	var tree = get_tree()
	if tree:
		await tree.create_timer(1.5).timeout
		
		# Check again if the tree still exists before reloading
		if is_inside_tree():
			get_tree().reload_current_scene()
		else:
			# If the spike was deleted, we can try to find the tree 
			# through the engine main loop as a backup
			Engine.get_main_loop().reload_current_scene()
