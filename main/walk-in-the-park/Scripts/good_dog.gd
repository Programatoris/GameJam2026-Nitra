extends Node2D

@onready var detection_area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var triggered := false

func _ready() -> void:
	# Pripojíme signál pre kolíziu
	detection_area.body_entered.connect(_on_body_entered)
	

func _on_body_entered(body: Node) -> void:
	# Ak do oblasti vojde objekt zo skupiny "player"
	if body.is_in_group("player"):
		# Spustíme animáciu (ak ešte nebeží alebo ak ju chceš reštartovať)
		if sprite.sprite_frames.has_animation("default"):
			sprite.play("default")
		
		# Ak chceš, aby sa animácia spustila len raz pri prvom dotyku, 
		# odkomentuj riadky nižšie:
		# if triggered: return
		# triggered = true
