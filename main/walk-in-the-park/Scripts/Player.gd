extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -225.0
@onready var gravity_value = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var is_dead := false
var can_double_jump := false
var is_flipped := false
# PODSTATNÉ PRE LÚČ: Uloženie štartovacej pozície
var start_position : Vector2

func _ready() -> void:
	add_to_group("player")
	sprite.play("default")
	safe_margin = 0.15
	# PODSTATNÉ PRE LÚČ: Zapamätanie si miesta štartu
	start_position = global_position

func flip_visual():
	is_flipped = !is_flipped
	
	if is_flipped:
		up_direction = Vector2.DOWN
		sprite.flip_v = true
		sprite.offset.y = 9 
	else:
		up_direction = Vector2.UP
		sprite.flip_v = false
		sprite.offset.y = 0
	
	position.y += 5.0 if is_flipped else -5.0
	velocity.y = 0
	
	set_collision_mask_value(1, false)
	await get_tree().process_frame
	set_collision_mask_value(1, true)

func _physics_process(delta: float) -> void:
	if is_dead: return
	
	if not is_on_floor():
		var gravity_direction = -1 if is_flipped else 1
		velocity.y += gravity_value * gravity_direction * delta
	
	
	if Input.is_action_just_pressed("ui_accept"):
		var jump_dir = 1 if is_flipped else -1
		if is_on_floor():
			velocity.y = abs(JUMP_VELOCITY) * jump_dir
		elif can_double_jump:
			velocity.y = abs(JUMP_VELOCITY - 100) * jump_dir
			can_double_jump = false
	
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		var h_offset = -15 if direction < 0 else 0
		sprite.offset = Vector2(h_offset, sprite.offset.y)
		
		if sprite.animation != "pohyb": sprite.play("pohyb")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if sprite.animation != "default": sprite.play("default")
	
	move_and_slide()

# PODSTATNÉ PRE LÚČ: Upravená funkcia smrti a resetu
func die():
	if is_dead: return
	is_dead = true
	velocity = Vector2.ZERO
	sprite.play("death_animation")
	
	# Počkáme sekundu na animáciu smrti
	await get_tree().create_timer(2).timeout
	
	# RESET HRÁČA
	global_position = start_position
	
	# Ak zomrel otočený, vrátime gravitáciu do normálu
	if is_flipped:
		flip_visual()
	
	# Oživenie
	is_dead = false
	collision_shape.set_deferred("disabled", false)
	sprite.play("default")
