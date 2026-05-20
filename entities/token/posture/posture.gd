@tool
class_name TokenPosture
extends Token


@export var type: Bozo.Posture:
	set(value_):
		type = value_
		texture_rect.texture = load("res://entities/token/images/%s.png" % [Catalog.posture_to_string[type]])
		texture_rect.modulate = Catalog.posture_to_color[type]

@export var value: int: 
	set(value_):
		value = value_
		label.text = str(value)
		visible = value > 0
