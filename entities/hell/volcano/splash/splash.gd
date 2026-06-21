class_name Splash
extends Label


var volcano: Volcano
var progression: Progression
var value: int = 1
var status: Bozo.Status = Bozo.Status.ON
var _tween: Tween


func reset(progression_: Progression, value_: int = 1, status_: Bozo.Status = Bozo.Status.ON):
	_stop_tween()
	progression = progression_
	value = value_
	text = str(value_)
	status = status_
	
	if get_parent():
		get_parent().remove_child(self)
	
	var y = randf_range(-0.25, -0.75) * Catalog.VOLCANO_SPRITE_SIZE.y
	position = Vector2(0, y)
	
	if value_ > 0:
		text = "+"+str(value_)
	if value_ < 0:
		text = "-"+str(value_)
	
	if progression_ == null or progression_.data == null:
		_return_to_pool()
		return
	
	var trial_data = progression_.data.boss.trial
	modulate = Catalog.trial_to_color[trial_data.type]
	z_index = 5
	visible = true
	pivot_offset = size / 2
	apply_tween()


func _stop_tween() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	_tween = null


func apply_tween() -> void:
	var x_sign = 1
	var progression_ref = progression
	
	match progression_ref.data.type:
		Bozo.Progression.TRIBUTE:
			progression_ref.current_label.add_child(self)
			x_sign = -1
		Bozo.Progression.FLAME:
			progression_ref.limit_label.add_child(self)
	
	_tween = get_tree().create_tween()
	_tween.set_parallel(true)

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
	var duration = Gear.splashs[Gear.tempo] * time_scale

	var start_pos = position

	_tween.tween_method(func(t):
		var time = t * duration
		var pos = start_pos + velocity * time
		pos.y += 0.5 * gravity * time * time
		position = pos
	, 0.0, 1.0, duration)

	_tween.finished.connect(_on_finished.bind(progression_ref, value), CONNECT_ONE_SHOT)

func _on_finished(progression_: Progression, value_: int) -> void:
	_tween = null
	
	if progression_ != null and is_instance_valid(progression_) and progression_.data != null:
		progression_.data.current_value += value_
	
	_return_to_pool()

func _return_to_pool() -> void:
	progression = null
	visible = false
	scale = Vector2.ONE
	if volcano:
		volcano.return_splash(self)
