@tool
class_name Modifier
extends PanelContainer


@export var icon: TextureRect
@export var label: RichTextLabel


@export var type: Bozo.Modifier:
	set(value_):
		type = value_
		if type == 0: return
		icon.texture = load("res://entities/hell/underground/shelter/modifier/images/%s.png" % Catalog.modifier_to_string[type])

@export var value: int:
	set(value_):
		value = value_
		label.text = str(value_) + "%"
