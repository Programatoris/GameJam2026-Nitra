extends Node2D

@onready var detection_area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D

var is_active := true

func _ready() -> void:
	detection_area.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node) -> void:
	# Reaguj len ak je pickup aktívny a koliduje s hráčom
	if is_active and body.is_in_group("player"):
		give_double_jump(body)

func give_double_jump(player: Node) -> void:
	is_active = false
	
	# Nastav hráčovi double jump (predpokladáme premennú v hráčovi)
	if "can_double_jump" in player:
		player.can_double_jump = true
	
	# Vizuálne skrytie (modulate alpha alebo visible)
	self.visible = false
	# Deaktivujeme kolíziu, aby hráč nemohol brať pickup, kým je skrytý
	detection_area.set_deferred("monitoring", false)
	
	# Čakanie 2 sekundy a opätovné zobrazenie
	await get_tree().create_timer(2.0).timeout
	respawn_pickup()

func respawn_pickup() -> void:
	is_active = true
	self.visible = true
	detection_area.set_deferred("monitoring", true)
