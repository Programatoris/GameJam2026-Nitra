extends Node2D

@onready var area: Area2D = $Area2D
var triggered := false

func _ready() -> void:

	start_floating_movement()

func start_floating_movement() -> void:
	# Vytvoríme Tween pre plynulý pohyb
	var tween = create_tween().set_loops() # set_loops() zabezpečí nekonečné opakovanie
	
	# Pohyb nahor o 200 pixelov (relatívne k aktuálnej pozícii)
	# TRANS_SINE a EASE_IN_OUT dodajú pohybu "hladký" charakter
	tween.tween_property(self, "position:x", position.x - 200, 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Pohyb späť nadol na pôvodnú pozíciu
	tween.tween_property(self, "position:x", position.x, 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
