extends Node2D

@onready var area: Area2D = $Area2D
var triggered := false

func _ready() -> void:
	add_to_group("enemies")
	area.body_entered.connect(_on_body_entered)
	
	# Spustíme pohyb hneď po načítaní
	start_floating_movement()

func start_floating_movement() -> void:
	# Vytvoríme Tween pre plynulý pohyb
	var tween = create_tween().set_loops() # set_loops() zabezpečí nekonečné opakovanie
	
	# Pohyb nahor o 200 pixelov (relatívne k aktuálnej pozícii)
	# TRANS_SINE a EASE_IN_OUT dodajú pohybu "hladký" charakter
	tween.tween_property(self, "position:x", position.x - 200, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Pohyb späť nadol na pôvodnú pozíciu
	tween.tween_property(self, "position:x", position.x, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body: Node) -> void:
	if triggered:
		return

	if body.is_in_group("player"):
		triggered = true
		
		if body.has_method("die"):
			body.die()
		
		reset_level()

func reset_level() -> void:
	await get_tree().create_timer(1.5).timeout
	get_tree().reload_current_scene()
