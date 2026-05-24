@tool
class_name TokenSin
extends Token


@export var type: Bozo.Sin:
	set(value_):
		type = value_
		if type == 0: return
		texture_rect.texture = load("res://entities/ui/token/images/sin.png")
		texture_rect.modulate = Catalog.sin_to_color[type]
