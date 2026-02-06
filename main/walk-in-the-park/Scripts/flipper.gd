extends Node2D

func _ready() -> void:
	var area = $Area2D
	if area:
		area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Už nevoláme PhysicsServer, ale povieme hráčovi, aby sa otočil
		if body.has_method("flip_visual"):
			body.flip_visual()
		
		# Deaktivácia pickupu (používame set_deferred pre bezpečnosť s fyzikou)
		visible = false
		$Area2D.set_deferred("monitoring", false)
		
		# Po 3 sekundách sa vráti
		await get_tree().create_timer(3.0).timeout
		visible = true
		$Area2D.set_deferred("monitoring", true)
