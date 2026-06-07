@tool
class_name TokenAmber
extends Token


@export var deal: Deal
@export var bank: Bank


func _on_value_changed() -> void:
	super._on_value_changed()

func apply_data_info() -> void:
	super.apply_data_info()
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/amber/amber on.png")
	texture_rect.modulate = Catalog.amber_to_color[data.type]
