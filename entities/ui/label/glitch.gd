extends RichTextEffect
class_name RichTextGlitch

var bbcode := "glitch"

@export var intensity: float = 4.0
@export var flicker_speed: float = 2.0
@export var flicker_chance: float = 0.06
@export var update_rate: float = 0.15

# --- CACHE (SOA instead of AOS) ---
var _step: PackedInt32Array = PackedInt32Array()
var _dx: PackedFloat32Array = PackedFloat32Array()
var _dy: PackedFloat32Array = PackedFloat32Array()
var _rot: PackedFloat32Array = PackedFloat32Array()
var _scale: PackedFloat32Array = PackedFloat32Array()
var _hide: PackedByteArray = PackedByteArray()

func _process_custom_fx(char_fx: CharFXTransform) -> bool:

	var id := char_fx.relative_index

	# grow arrays only if needed
	if id >= _step.size():
		_step.resize(id + 1)
		_dx.resize(id + 1)
		_dy.resize(id + 1)
		_rot.resize(id + 1)
		_scale.resize(id + 1)
		_hide.resize(id + 1)

	var t := Time.get_ticks_msec() / 2000.0 * flicker_speed
	var step := int(t / update_rate)

	# update only if needed
	if _step[id] != step:

		_step[id] = step

		_dx[id] = randf_range(-intensity, intensity)
		_dy[id] = randf_range(-intensity * 0.5, intensity * 0.5)

		_rot[id] = randf_range(-0.3, 0.3)
		_scale[id] = randf_range(0.85, 1.15)

		_hide[id] = 1 if randf() < flicker_chance else 0

	# hide case (fast branch)
	if _hide[id] == 1:
		char_fx.color.a = 0.0
		return true

	# apply transform (no intermediate dicts)
	var origin := char_fx.transform.get_origin()

	var rot := Transform2D(_rot[id], Vector2.ZERO)
	var scl := Transform2D().scaled(Vector2(_scale[id], _scale[id]))

	char_fx.transform = Transform2D() * rot * scl
	char_fx.transform.origin = origin + Vector2(_dx[id], _dy[id])

	# cheap flicker (no sin per character alternative)
	var flicker := 0.9 + 0.1 * sin(char_fx.elapsed_time * 10.0 + id)
	char_fx.color.a *= flicker

	return true

func reset_cache():
	_step = PackedInt32Array()
	_dx = PackedFloat32Array()
	_dy = PackedFloat32Array()
	_rot = PackedFloat32Array()
	_scale = PackedFloat32Array()
	_hide = PackedByteArray()
