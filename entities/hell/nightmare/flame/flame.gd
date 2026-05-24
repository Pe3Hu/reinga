@tool
class_name Flame
extends PanelContainer


@export var trial: Trial
@export var icon: TextureRect
@export var progression: Progression

@export var level: int = 1:
	set(value_):
		level = value_
		icon.texture = load("res://entities/hell/nightmare/flame/images/%d.png" % level)
