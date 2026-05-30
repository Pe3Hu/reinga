@tool
class_name TokenDesire
extends Token


@export var dream: Dream

func _ready() -> void:
	texture_rect.material = ShaderMaterial.new()
	texture_rect.material.shader = load("uid://c2fs5w3yu3jk3")
	texture_rect.material.set_shader_parameter("noiseTexture", NoiseTexture2D.new())

func apply_data_info() -> void:
	super.apply_data_info()
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

func dissolve():
	if texture_rect.material and texture_rect.material is ShaderMaterial:
		var tween = create_tween()
		var duration = randf_range(0.9, 1.1) * Catalog.DESIRE_DISSOLVE_DURATION
		var angle = Helper.rng.randf_range(0.0, 360.0)
		texture_rect.material.set_shader_parameter("direction", angle)
		tween.tween_method(update_progress, -1.5, 1.6, duration)
		tween.tween_callback(func():
			dream.end_dissolve(self)
		)
	 
func update_progress(value_: float):
	if texture_rect.material:
		texture_rect.material.set_shader_parameter("progress", value_)
