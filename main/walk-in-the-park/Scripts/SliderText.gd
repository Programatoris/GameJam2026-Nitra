extends HSlider


#================================================================================
# Variables
@onready var slider_text: Label = get_node("../Label")
@onready var slider_name_tag: Label = get_node("../../Label")


#================================================================================
# Functions
func _ready() -> void:
	setValues()
	var slider_name_tag_text: String = parseAndConstructText(slider_name_tag.text)
	if slider_name_tag_text == "Music":
		SoundManager.musicGroup()
	else:
		SoundManager.effectsGroups()
	handleSignals()


func handleSignals() -> void:
	value_changed.connect(on_h_slider_value_changed)


func on_h_slider_value_changed(_value):
	slider_text.text =  str(value)
	var slider_name_tag_text: String = parseAndConstructText(slider_name_tag.text)
	Data.data["settings"][slider_name_tag_text] = value
	Data.saveData()
	
	if slider_name_tag_text == "Music":
		SoundManager.musicGroup()
	else:
		SoundManager.effectsGroups()


#==================================================
# Helper functions
func setValues() -> void:
	var slider_name_tag_text: String = parseAndConstructText(slider_name_tag.text)
	slider_text.text = str(Data.data["settings"][slider_name_tag_text])
	value = Data.data["settings"][slider_name_tag_text]


func parseAndConstructText(_raw_slider_name_tag_text: String) -> String:
	var slider_name_tag_text: String = ""
	
	for char in _raw_slider_name_tag_text:
		if char == " ":
			slider_name_tag_text += "_"
		else:
			slider_name_tag_text += char
	
	return slider_name_tag_text
