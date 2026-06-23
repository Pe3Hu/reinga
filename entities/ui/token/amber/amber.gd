@tool
class_name TokenAmber
extends Token


@export var deal: Deal
@export var bank: Bank
@export var safe: Safe


func _on_value_changed() -> void:
	super._on_value_changed()
	
	if data.value >= Catalog.ASCENSION_AMBER_COUNT:
		Scope.exodus = Bozo.Exodus.ASCENSION

func connect_signals() -> void:
	super.connect_signals()
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
	
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	texture_rect.texture = load("res://entities/ui/token/amber/amber on.png")
	texture_rect.modulate = Catalog.amber_to_color[data.type]

func click_event() -> void:
	super.click_event()
	
	if safe:
		if data.value > 0:
			if bank.active_safe != safe:
				bank.active_safe = safe
			else:
				bank.forget_safe()
