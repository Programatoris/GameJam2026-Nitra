extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -275.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		
		# Flip + offset
		sprite.flip_h = direction < 0
		sprite.offset = Vector2(-15, 0) if direction < 0 else Vector2.ZERO
		
		# Play run animation
		if sprite.animation != "pohyb":
			sprite.play("pohyb")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Play idle animation
		if sprite.animation != "default":
			sprite.play("default")
	
	move_and_slide()
