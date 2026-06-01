class_name Pressure
extends Sprite2D


var data: PressureData
var volcano: Volcano
var eruption: Eruption:
	set(value_):
		eruption = value_
		data = eruption.data.pressure
		reset()

@export var timer: Timer

func reset() -> void:
	rotation_degrees = 0
	if data.type == Bozo.Modifier.MISS:
		rotation_degrees = 45
	
	var angle = randf_range(0, 2 * PI)
	var l = randf_range(0.8, 1.2) * Catalog.PRESSURE_OFFSET_L
	var offest = Vector2.from_angle(angle) * l
	global_position = eruption.global_position + offest
	texture = load("res://entities/hell/volcano/pressure/images/%s.png" % Catalog.modifier_to_string[data.type])
	timer.wait_time = Catalog.PRESSURE_DURATION / data.limit_step
	#z_index = 0
	visible = true
	modulate = Catalog.token_to_color[eruption.start_token.data.type]
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var step = float(data.current_step) / data.limit_step
	scale = Vector2.ONE * step
	modulate.a = step
	data.current_step -= 1
	
	if data.current_step > 0:
		timer.start()
	else:
		modulate.a = 0.0
		volcano.return_pressure(self)
