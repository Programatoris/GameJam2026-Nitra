extends Node2D

@export var spike_scene: PackedScene # Tu v Inspectore priraď FallingSpike.tscn
@onready var health_bar = $CanvasLayer/ProgressBar # Uprav cestu k bar-u
@onready var health_timer = $HealthTimer
@onready var spawn_timer = $SpawnTimer

func _ready():
	health_bar.max_value = 60 # Dĺžka bossfightu v sekundách
	health_bar.value = 60
	
	# Pripojenie signálov
	health_timer.timeout.connect(_on_health_timer_timeout)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_health_timer_timeout():
	health_bar.value -= 1
	
	if health_bar.value <= 0:
		win_bossfight()

func _on_spawn_timer_timeout():
	# Vytvoríme inštanciu ostňa
	var spike = spike_scene.instantiate()
	
	# Náhodná X pozícia nad obrazovkou (uprav podľa šírky tvojho levelu)
	var random_x = randf_range(50, 1100) 
	spike.position = Vector2(random_x, -50) # Začína nad horným okrajom
	
	add_child(spike)

func win_bossfight():
	health_timer.stop()
	spawn_timer.stop()
	print("Boss porazený!")
	# Tu môžeš prepnúť scénu alebo spustiť animáciu výhry
