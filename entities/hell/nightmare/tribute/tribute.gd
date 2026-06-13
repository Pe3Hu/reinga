@tool
class_name Tribute
extends PanelContainer


var data: TributeData:
	set(value_):
		data = value_
		apply_data_info()

@export var trial: Trial
@export var icon: TextureRect
@export var progression: Progression


func apply_data_info() -> void:
	progression.data = data.progression
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func start_drain() -> void:
	trial.nightmare.drain_tributes.append(self)
	var duration = progression.data.current_value * Catalog.DRAIN_TICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(progression.data, "current_value", 0, duration)
	tween.tween_callback(func():
		trial.nightmare.end_tribute_drain(self)
	)

func _on_type_changed() -> void:
	if data.type == 0: return
	icon.texture = load("res://entities/hell/nightmare/tribute/images/%s.png" % Catalog.half_to_string[data.type])
	icon.material.set_shader_parameter("mask_texture", load("res://entities/hell/nightmare/tribute/images/%s.png" % Catalog.half_to_string[data.type]))
