@tool
class_name TokenFaction
extends Token


func apply_data_info() -> void:
	super.apply_data_info()
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	#texture_rect.texture = load("res://entities/token/images/faction.png")
	texture_rect.modulate = Catalog.faction_to_color[data.type]
