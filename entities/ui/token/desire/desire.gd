@tool
class_name TokenDesire
extends Token


@export var dream: Dream


#region init
func _ready() -> void:
	texture_rect.material = ShaderMaterial.new()
	texture_rect.material.shader = load("uid://c2fs5w3yu3jk3")
	texture_rect.material.set_shader_parameter("noiseTexture", NoiseTexture2D.new())

func connect_signals() -> void:
	super.connect_signals()
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
		_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/desire/images/%s.png" % Catalog.desire_to_string[data.type])
	
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var trial_type = Catalog.desire_to_trial[data.type]
		visible = true
		texture_rect.visible = true
		texture_rect.material.set_shader_parameter("color_start", Catalog.trial_to_color[trial_type])
		texture_rect.material.set_shader_parameter("color_end", Catalog.desire_to_color[data.type])
		texture_rect.material.set_shader_parameter("angle", Catalog.desire_to_angle[data.type])
#endregion

func reset() -> void:
	texture_rect.visible = false
	update_progress(Catalog.DESIRE_PROGRESS_LIMIT)

func refill_progress() -> void:
	texture_rect.visible = true
	update_progress(-Catalog.DESIRE_PROGRESS_LIMIT)

func payment_dissolve() -> void:
	if !dream:
		push_warning("TokenDesire.dissolve_payment: missing dream")
		return
	
	if !data or data.value == 0:
		texture_rect.visible = false
		dream.end_payment_dissolve(self)
		return
	
	if !(texture_rect.material is ShaderMaterial):
		texture_rect.visible = false
		dream.end_payment_dissolve(self)
		return
	
	dissolve()

func dissolve():
	if data.value == 0: return
	
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		texture_rect.visible = true
		var tween = create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		var duration = randf_range(0.9, 1.1) * Gear.desire_dissolves[Gear.tempo]
		var angle = Helper.rng.randf_range(0.0, 360.0)
		texture_rect.material.set_shader_parameter("direction", angle)
		tween.tween_method(update_progress, -Catalog.DESIRE_PROGRESS_LIMIT, Catalog.DESIRE_PROGRESS_LIMIT, duration)
		end_dissolve(tween)

func end_dissolve(tween_: Tween) -> void:
	match data.association:
		Bozo.Association.GUILD:
			tween_.tween_callback(func():
				dream.end_guild_dissolve(self)
			)
		_:
			tween_.tween_callback(func():
				dream.end_payment_dissolve(self)
			)

func update_progress(value_: float):
	if texture_rect.material:
		texture_rect.material.set_shader_parameter("progress", value_)

func appear() -> void:
	if data.value == 0: return
	
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		texture_rect.visible = true
		var tween = create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		var duration = randf_range(0.9, 1.1) * Gear.desire_dissolves[Gear.tempo]
		var angle = Helper.rng.randf_range(0.0, 360.0)
		texture_rect.material.set_shader_parameter("direction", angle)
		tween.tween_method(update_progress, Catalog.DESIRE_PROGRESS_LIMIT, -Catalog.DESIRE_PROGRESS_LIMIT, duration)
