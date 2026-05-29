@tool
class_name TokenAmber
extends Token


func _on_value_changed() -> void:
	super._on_value_changed()
	visible = true

func apply_data_info() -> void:
	super.apply_data_info()
	apply_type()

func apply_type() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/images/amber.png")
	texture_rect.modulate = Catalog.amber_to_color[data.type]
