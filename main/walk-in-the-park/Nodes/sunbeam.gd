extends Node2D

@onready var ray: RayCast2D = $RayCast2D
@onready var line: Line2D = $Line2D
@onready var kill_timer: Timer = $Timer

var player: CharacterBody2D = null
var is_burning := false

# Offset 10 pixelov doľava od stredu hráča
const OFFSET_X = 0

func _ready() -> void:
	# Nájdenie hráča v skupine
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	# Základný vizuál lúča
	line.width = 10.0
	line.default_color = Color(1, 1, 0, 0.4)
	
	# Pripojenie signálu časovača
	if not kill_timer.timeout.is_connected(_on_kill_timer_timeout):
		kill_timer.timeout.connect(_on_kill_timer_timeout)

func _physics_process(_delta: float) -> void:
	# Ak hráč neexistuje alebo sa práve resetuje po smrti
	if player == null or player.is_dead:
		if is_burning:
			stop_burning()
		line.visible = false
		return
	
	line.visible = true
	
	# 1. Výpočet cieľa s offsetom
	var target_global_pos = player.global_position + Vector2(OFFSET_X, 0)
	var local_target = to_local(target_global_pos)
	
	# 2. Aktualizácia RayCastu
	ray.target_position = local_target
	ray.force_raycast_update() 

	# 3. Vykresľovanie čiary (Line2D)
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	if ray.is_colliding():
		# Lúč vizuálne skončí presne tam, kde narazil (stena alebo hráč)
		var collision_point = to_local(ray.get_collision_point())
		line.add_point(collision_point)
		
		var collider = ray.get_collider()
		
		# DETEKCIA: Kontrolujeme priamo objekt alebo skupinu
		if collider == player or collider.is_in_group("player"):
			if not is_burning:
				start_burning()
		else:
			# Ak trafil niečo iné (stenu, bedňu), hráč je v bezpečí
			if is_burning:
				stop_burning()
	else:
		# Ak netrafil nič (napr. hráč je mimo dosahu), nakreslí sa celá dĺžka
		line.add_point(local_target)
		if is_burning:
			stop_burning()

func start_burning():
	is_burning = true
	line.default_color = Color(1, 0, 0, 0.7) # Červená pri pálení
	kill_timer.start()

func stop_burning():
	is_burning = false
	line.default_color = Color(1, 1, 0, 0.4) # Návrat k žltej
	kill_timer.stop()

func _on_kill_timer_timeout() -> void:
	if is_burning and player:
		stop_burning()
		if player.has_method("die"):
			player.die()
			reset_level()
			
func reset_level() -> void:
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
