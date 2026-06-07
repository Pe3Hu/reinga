class_name Splash
extends Label


var volcano: Volcano
var progression: Progression
var value: int = 1
var status: Bozo.Status = Bozo.Status.ON


func reset(progression_: Progression, value_: int = 1, status_: Bozo.Status = Bozo.Status.ON):
	progression = progression_
	value = value_
	text = str(value_)
	status = status_
	
	get_parent().remove_child(self)
	
	var y = randf_range(-0.25, -0.75) * Catalog.VOLCANO_SPRITE_SIZE.y
	position = Vector2(0, y)
	
	if value_ > 0:
		text = "+"+str(value_)
	if value_ < 0:
		text = "-"+str(value_)
	
	var trial_data = progression.data.boss.trial
	modulate = Catalog.trial_to_color[trial_data.type]
	z_index = 5
	visible = true
	#await resized
	pivot_offset = size / 2
	apply_tween()


func apply_tween() -> void:
	var x_sign = 1
	
	match progression.data.type:
		Bozo.Progression.TRIBUTE:
			progression.current_label.add_child(self)
			x_sign = -1
		Bozo.Progression.FLAME:
			progression.limit_label.add_child(self)
	
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
	progression.data.current_value += value
	progression = null
	visible = false
	scale = Vector2.ONE
	volcano.return_splash(self)
