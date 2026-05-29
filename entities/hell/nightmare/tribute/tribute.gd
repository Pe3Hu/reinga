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


func start_drain() -> void:
	trial.nightmare.drain_tributes.append(self)
	var duration = progression.current_value * Catalog.DRAIN_TICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(progression, "current_value", 0, duration)
	tween.tween_callback(func():
		trial.nightmare.end_tribute_drain(self)
	)
