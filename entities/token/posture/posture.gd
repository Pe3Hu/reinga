@tool
class_name TokenPosture
extends Token


@export var type: Bozo.Posture = Bozo.Posture.NONE:
	set(value_):
		type = value_
		if type == 0: return
		texture_rect.texture = load("res://entities/token/images/%s.png" % [Catalog.posture_to_string[type]])
		texture_rect.modulate = Catalog.posture_to_color[type]
