class_name Splash
extends Label


var volcano: Volcano
var progression: Progression
var value: int = 1


func reset(progression_: Progression, value_: int = 1):
	get_parent().remove_child(self)
	var x_sign = 1
	
	match progression_.type:
		Bozo.Progression.TRIBUTE:
			progression_.current_label.add_child(self)
			x_sign = -1
		Bozo.Progression.FLAME:
			progression_.limit_label.add_child(self)
	
	value = value_
	progression = progression_
	var y = randf_range(-0.25, -0.75) * Catalog.VOLCANO_SPRITE_SIZE.y
	position = Vector2(0, y)
	text = str(value_)
	if value_ > 0:
		text = "+"+str(value_)
	
	var trial = progression.get_parent().get_parent().trial
	modulate = Catalog.trial_to_color[trial.type]
	z_index = 5
	visible = true
	#await resized
	pivot_offset = size / 2

	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	var angle_deg = randf_range(60.0, 80.0)
	var force = randf_range(0.8, 1.2)
	var time_scale = randf_range(0.9, 1.1)

	var angle = deg_to_rad(angle_deg)
	var speed = 150.0 * force

	var velocity = Vector2(
		x_sign * cos(angle) * speed,
		-sin(angle) * speed
	)

	var gravity = 600.0
	var duration = Catalog.SPASH_DURATION * time_scale

	var start_pos = position

	tween.tween_method(func(t):
		var time = t * duration
		var pos = start_pos + velocity * time
		pos.y += 0.5 * gravity * time * time
		position = pos
	, 0.0, 1.0, duration)

	tween.finished.connect(_on_finished)

func _on_finished():
	progression.current_value += value
	progression = null
	visible = false
	scale = Vector2.ONE
	volcano.return_splash(self)
