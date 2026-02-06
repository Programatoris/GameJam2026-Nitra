extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -225.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_dead := false
var can_double_jump := false # Premenná, ktorú mení pickup

func _ready() -> void:
	add_to_group("player")
	sprite.play("default")

func die():
	if is_dead:
		return
	is_dead = true
	
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	sprite.play("death_animation")

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# Gravitácia
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Jump logika
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			# Normálny skok zo zeme
			velocity.y = JUMP_VELOCITY
		elif can_double_jump:
			# Extra skok vo vzduchu z pickupu
			velocity.y = JUMP_VELOCITY - 100
			can_double_jump = false # Bonus sa po použití minie

	# Movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		
		sprite.flip_h = direction < 0
		sprite.offset = Vector2(-15, 0) if direction < 0 else Vector2.ZERO
		
		if sprite.animation != "pohyb":
			sprite.play("pohyb")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		if sprite.animation != "default":
			sprite.play("default")
	
	move_and_slide()
