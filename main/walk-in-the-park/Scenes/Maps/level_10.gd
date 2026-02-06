extends Node2D

@export var spike_scene: PackedScene
@export var player_path: NodePath # Priraď hráča v Inspectore

@onready var health_bar = $CanvasLayer/ProgressBar
@onready var health_timer = $HealthTimer
@onready var spawn_timer = $SpawnTimer
@onready var canvas_layer = $CanvasLayer
@onready var victory_label = $CanvasLayer/Label # Pridaný odkaz na Label
@onready var dog_final = $DogFinal 
@onready var player = get_node(player_path)

# --- Nastavenia plochy ---
var screen_width = 750 
var screen_start = -650 
var safe_zone_width = 180 
var spike_size = 16 
var speed_dog = 150.0
var fight_won = false

@onready var center_x = (screen_start + screen_width) / 2

func _ready():
	health_bar.max_value = 45
	health_bar.value = 45
	health_timer.timeout.connect(_on_health_timer_timeout)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	# Na začiatku skryjeme psa aj Label
	if dog_final:
		dog_final.hide()
	if victory_label:
		victory_label.hide()

func _process(delta: float) -> void:
	# Logika pohybu psa po výhre
	if fight_won and dog_final and player:
		var direction = player.global_position - dog_final.global_position
		var distance = direction.length()
		var sprite = dog_final.get_node_or_null("AnimatedSprite2D")

		if distance > 50:
			var velocity = direction.normalized() * speed_dog
			dog_final.global_position += velocity * delta
			if sprite:
				sprite.play("run")
				sprite.flip_h = velocity.x < 0
		else:
			if sprite:
				sprite.play("happy")

func _on_health_timer_timeout():
	health_bar.value -= 1
	if health_bar.value <= 0:
		win_bossfight()

func _on_spawn_timer_timeout():
	spawn_single_spike(randf_range(screen_start, screen_width))
	if health_bar.value <= (health_bar.max_value * 0.5):
		if randf() < 0.1: 
			spawn_full_walls()

func spawn_full_walls():
	var gap_half = safe_zone_width / 2
	var safe_left = center_x - gap_half
	var safe_right = center_x + gap_half
	var x_left = screen_start
	while x_left < safe_left:
		create_delayed_spike(x_left, abs(x_left - screen_start) * 0.0008)
		x_left += spike_size
	var x_right = screen_width
	while x_right > safe_right:
		create_delayed_spike(x_right, abs(x_right - screen_width) * 0.0008)
		x_right -= spike_size

func create_delayed_spike(x_pos: float, delay: float):
	await get_tree().create_timer(delay).timeout
	if is_inside_tree(): 
		spawn_single_spike(x_pos)

func spawn_single_spike(x_pos: float):
	if !spike_scene: return
	var spike = spike_scene.instantiate()
	spike.position = Vector2(x_pos, -100)
	add_child(spike)

func win_bossfight():
	health_timer.stop()
	spawn_timer.stop()
	health_bar.hide() 
	
	fight_won = true
	
	# Zobrazenie psa
	if dog_final:
		dog_final.show()
	
	# Zobrazenie textu víťazstva
	if victory_label:
		victory_label.add_theme_font_size_override("font_size", 50)
		victory_label.text = "Thanks For Playing" # Môžeš tu nastaviť ľubovoľný text
		victory_label.show()
	
