@tool
class_name TokenPosture
extends Token


func apply_data_info() -> void:
	super.apply_data_info()
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/images/%s.png" % [Catalog.posture_to_string[data.type]])
	texture_rect.modulate = Catalog.posture_to_color[data.type]
