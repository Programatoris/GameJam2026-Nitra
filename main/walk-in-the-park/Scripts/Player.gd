extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -200.0

# Reference to the sprite node
@onready var sprite = $AnimatedSprite2D  # Change this to match your sprite node name

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		
		# Flip sprite based on direction
		if direction < 0:  # Moving left
			sprite.flip_h = true
		elif direction > 0:  # Moving right
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
