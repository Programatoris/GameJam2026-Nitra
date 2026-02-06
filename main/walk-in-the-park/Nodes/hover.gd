extends Button


#================================================================================
# Variables
@onready var button_hover: AudioStreamPlayer = $ButtonHover


#================================================================================
# Functions
func _ready() -> void:
	mouse_entered.connect(playHoverEffects)


func _process(delta: float) -> void:
	pass


func playHoverEffects() -> void:
	button_hover.play()
