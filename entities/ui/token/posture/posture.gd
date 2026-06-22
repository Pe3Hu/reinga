@tool
class_name TokenPosture
extends Token


@export var bank: Bank
@export var contribution: Contribution


func connect_signals() -> void:
	super.connect_signals()
	data.type_changed.connect(_on_type_changed)
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/posture/images/%s.png" % [Catalog.posture_to_string[data.type]])
	texture_rect.modulate = Catalog.posture_to_color[data.type]

func click_event() -> void:
	super.click_event()
	
	if contribution != null:
		contribution.treasury.reoder(data.type)
		await get_tree().process_frame
		contribution.treasury.sort_icon_shift(self)

func _on_value_changed():
	super._on_value_changed()
	
	if bank and data.value == 0:
		bank.data.activate_posture(data)
	
