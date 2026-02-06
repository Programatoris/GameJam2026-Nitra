extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -225.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_dead := false

func _ready() -> void:
	add_to_group("player")
	sprite.play("default")

func die():
	if is_dead:
		return
	is_dead = true
	
	velocity = Vector2.ZERO
	$CollisionShape2D.disabled = true
	sprite.play("death_animation")

func _physics_process(delta: float) -> void:
	# Don't process movement if dead
	if is_dead:
		return
	
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
