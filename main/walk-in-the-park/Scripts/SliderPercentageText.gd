extends HSlider


#==================================================
# Variables
@onready var label: Label = $"../Label"


#==================================================
# Functions
func _ready() -> void:
	var scale_factor: float = 1.5
	$"../../../..".scale = Vector2(scale_factor, scale_factor)

func _process(delta: float) -> void:		
	label.text =  str(value)
