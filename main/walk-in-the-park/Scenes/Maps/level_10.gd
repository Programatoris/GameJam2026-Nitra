extends Node2D

@export var spike_scene: PackedScene
@onready var health_bar = $CanvasLayer/ProgressBar
@onready var health_timer = $HealthTimer
@onready var spawn_timer = $SpawnTimer

# --- Nastavenia plochy ---
var screen_width = 750 
var screen_start = -650 
var safe_zone_width = 180 
var spike_size = 16 # Späť na 16, aby neboli diery v stene

@onready var center_x = (screen_start + screen_width) / 2

func _ready():
	health_bar.max_value = 45
	health_bar.value = 45
	health_timer.timeout.connect(_on_health_timer_timeout)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_health_timer_timeout():
	health_bar.value -= 1
	if health_bar.value <= 0:
		win_bossfight()

func _on_spawn_timer_timeout():
	# 1. Bežný ošteň padá vždy (aby sa hráč nenudil)
	spawn_single_spike(randf_range(screen_start, screen_width))

	# 2. Logika pre 50% HP a menej
	if health_bar.value <= (health_bar.max_value * 0.5):
		# randf() generuje číslo od 0 do 1. 
		# 0.1 znamená, že stena sa vygeneruje len v 10% prípadov (výrazne znížená frekvencia)
		if randf() < 0.1: 
			spawn_full_walls()

func spawn_full_walls():
	var gap_half = safe_zone_width / 2
	var safe_left = center_x - gap_half
	var safe_right = center_x + gap_half
	
	# Ľavá stena (plná)
	var x_left = screen_start
	while x_left < safe_left:
		# Jemné oneskorenie pre efekt "zaťahovania opony"
		var delay = abs(x_left - screen_start) * 0.0008
		create_delayed_spike(x_left, delay)
		x_left += spike_size
		
	# Pravá stena (plná)
	var x_right = screen_width
	while x_right > safe_right:
		var delay = abs(x_right - screen_width) * 0.0008
		create_delayed_spike(x_right, delay)
		x_right -= spike_size

func create_delayed_spike(x_pos: float, delay: float):
	var tree = get_tree()
	if tree:
		await tree.create_timer(delay).timeout
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
	print("Boss porazený!")
