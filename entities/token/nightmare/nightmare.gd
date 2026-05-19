@tool
class_name TokenNightmare
extends Token


@export var type: Bozo.Nightmare:
	set(value_):
		type = value_
		texture_rect.texture = load("res://entities/token/images/nightmare.png")
		texture_rect.modulate = Catalog.nightmare_to_color[type]
@export var value: int: 
	set(value_):
		value = value_
		label.text = str(value)
