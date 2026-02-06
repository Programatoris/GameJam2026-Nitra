extends Node2D

@onready var detection_area: Area2D = $DetectionArea
@onready var kill_area: Area2D = $KillArea

var triggered := false
var is_falling := false
var fall_speed := 350.0
var detection_range := 50000.0

var player: Node2D = null

func _ready() -> void:
	add_to_group("enemies")
	
	# Setup detection area
	if detection_area == null:
		push_error("DetectionArea not found!")
		return
	detection_area.body_entered.connect(_on_detection_entered)
	detection_area.body_exited.connect(_on_detection_exited)
	
	# Setup kill area
	if kill_area == null:
		push_error("KillArea not found!")
		return
	kill_area.body_entered.connect(_on_kill_entered)

func _process(delta: float) -> void:
	# Check distance to player for detection
	if not triggered and player != null:
		var distance = global_position.distance_to(player.global_position)
		if distance <= detection_range:
			start_falling()
	
	# Fall if triggered
	if is_falling:
		position.y += fall_speed * delta

func _on_detection_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body

func _on_detection_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player = null

func _on_kill_entered(body: Node) -> void:
	# Only kill if falling
	if is_falling and body.is_in_group("player"):
		if body.has_method("die"):
			body.die()
		reset_level()

func start_falling() -> void:
	if triggered:
		return
	triggered = true
	is_falling = true
	
	# Despawn after 5 seconds
	await get_tree().create_timer(5.0).timeout
	queue_free()

func reset_level() -> void:
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
