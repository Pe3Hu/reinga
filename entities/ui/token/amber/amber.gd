@tool
class_name TokenAmber
extends Token


@export var type: Bozo.Amber:
	set(value_):
		type = value_
		if type == 0: return
		texture_rect.texture = load("res://entities/ui/token/images/amber.png")
		texture_rect.modulate = Catalog.amber_to_color[type]
