extends AnimatableBody2D # Zmenené z Node2D

func _ready() -> void:
	start_floating_movement()

func start_floating_movement() -> void:
	# Vytvoríme Tween, ktorý bude hýbať platformou
	var tween = create_tween().set_loops().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	# DÔLEŽITÉ: Používame relatívny pohyb, aby sme nemuseli fixovať súradnice
	var target_x = position.x - 200
	var start_x = position.x
	
	# Pohyb tam
	tween.tween_property(self, "position:x", target_x, 4.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	# Pohyb späť
	tween.tween_property(self, "position:x", start_x, 4.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
