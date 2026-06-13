@tool
class_name Flame
extends PanelContainer


var data: FlameData:
	set(value_):
		data = value_
		apply_data_info()

@export var trial: Trial
@export var icon: TextureRect
@export var progression: Progression



func apply_data_info() -> void:
	progression.data = data.progression
	data.level_changed.connect(_on_level_changed)
	_on_level_changed()

func _on_level_changed() -> void:
	icon.texture = load("res://entities/hell/nightmare/flame/images/%d.png" % data.level)
	icon.material.set_shader_parameter("mask_texture", load("res://entities/hell/nightmare/flame/images/%d.png" % data.level))
