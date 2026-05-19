@tool
class_name TokenSin
extends Token


@export var type: Bozo.Sin:
	set(value_):
		type = value_
		texture_rect.texture = load("res://entities/token/images/sin.png")
		texture_rect.modulate = Catalog.sin_to_color[type]
@export var value: int: 
	set(value_):
		value = value_
		label.text = str(value)
