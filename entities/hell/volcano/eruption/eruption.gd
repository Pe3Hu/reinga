class_name Eruption
extends Node2D


var volcano: Volcano
var token: TokenSin
var trial: Trial

var start: Vector2
var end: Vector2
var control: Vector2

var t := 0.0
var duration := 0.8

var active := false


func reset(token_: TokenSin, trial_: Trial):
	token = token_
	trial = trial_
	
	update_vectors()
	global_position = start
	t = 0.0
	active = true

	var mid = (start + end) * 0.5
	var dir = (end - start).normalized()
	var perp = Vector2(-dir.y, dir.x)

	control = mid + perp * randf_range(-180, 180)
	
	if token:
		modulate = Catalog.sin_to_color[token.type]
		token.value -= 1

func update_vectors() -> void:
	start = token.global_position
	var trial_token = trial.sin_to_token[token.type]
	end = trial_token.global_position
	
	var shift = Vector2.from_angle(randf() * PI * 2) * Catalog.ERUPTION_OFFSET_L
	start += shift
	#end -= shift

func _process(delta_):
	if !active:
		return

	t += delta_ / duration
	var time = clamp(t, 0, 1)

	global_position = bezier(start, control, end, time)

	if time >= 1.0:
		deactivate()

func deactivate():
	active = false
	visible = false
	set_process(false)
	volcano.return_eruption(self)
	
	if trial:
		var trial_token = trial.sin_to_token[token.type]
		trial_token.value -= 1

func activate():
	visible = true
	set_process(true)

func bezier(a_: Vector2, b_: Vector2, c_: Vector2, t_: float):
	var ab = a_.lerp(b_, t_)
	var bc = b_.lerp(c_, t_)
	return ab.lerp(bc, t_)
