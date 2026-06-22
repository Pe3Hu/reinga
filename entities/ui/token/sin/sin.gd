@tool
class_name TokenSin
extends Token


@export var contribution: Contribution
@export var claim: Claim


func _on_value_changed() -> void:
	super._on_value_changed()
	
	if claim:
		visible = data.value > 0

func connect_signals() -> void:
	super.connect_signals()
	
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
	
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	
	texture_rect.texture = load("res://entities/ui/token/sin/sin on.png")
	texture_rect.modulate = Catalog.sin_to_color[data.type]

func click_event() -> void:
	super.click_event()
	
	if contribution != null:
		contribution.treasury.reoder(data.type)
		await get_tree().process_frame
		contribution.treasury.sort_icon_shift(self)
