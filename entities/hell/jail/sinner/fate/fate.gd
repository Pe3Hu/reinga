class_name Fate
extends Panel


@export var sinner: Sinner
@export var type: Bozo.Fate:
	set(value_):
		type = value_
		if type == 0: return
		
		if label:
			unfocus()
			sinner.faction.visible = true
			sinner.faction.type = Catalog.fate_to_faction[type]

@export var label: RichTextLabel


func focus() -> void:
	label.text = "[pulse freq=0.66 color=#5b5b5b ease=-2.0]%s" % Catalog.fate_to_string[type].capitalize()

func unfocus() -> void:
	label.text = Catalog.fate_to_string[type].capitalize()
