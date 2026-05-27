@tool
class_name Tribute
extends PanelContainer


@export var trial: Trial
@export var icon: TextureRect
@export var progression: Progression

@export var type: Bozo.Half:
	set(value_):
		if type != value_:
			type = value_
			icon.texture = load("res://entities/hell/nightmare/tribute/images/%s.png" % Catalog.half_to_string[type])


func _ready() -> void:
	pass
