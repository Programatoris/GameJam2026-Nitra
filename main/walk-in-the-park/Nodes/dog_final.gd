extends Node2D

@export var speed: float = 100.0
@export var player_path: NodePath

@onready var player = get_node(player_path)
@onready var sprite = $AnimatedSprite2D # Make sure your node is named this!

func _process(delta: float) -> void:
	if not player:
		return

	var direction_to_player = player.global_position - global_position
	var distance = direction_to_player.length()

	if distance > 50:
		# --- RUNNING STATE ---
		var velocity = direction_to_player.normalized() * speed
		global_position += velocity * delta
		
		# Play the run animation
		sprite.play("run")
		
		# Flip the sprite based on direction
		sprite.flip_h = velocity.x > 0
	else:
		# --- HAPPY STATE ---
		# When we are close enough (under 50px), stop and be happy
		sprite.play("happy")
