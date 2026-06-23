class_name Seal
extends MarginContainer


var data: SealData:
	set(value_):
		data = value_
		
		connect_signals()

@export var trial: Trial
@export var earrings: Array[ColorRect]


func connect_signals() -> void:
	if data == null: return
	if !data.value_changed.is_connected(_on_value_changed):
		data.value_changed.connect(_on_value_changed)
	
	_on_value_changed()
	apply_type()
	apply_color()

func apply_type() -> void:
	if data.type == 0: return
	if data.type == Bozo.Seal.BLESS:
		var anchors = Catalog.windrose_to_anchor[Bozo.Windrose.NE]
		%Earring2.size_flags_horizontal = anchors.front()
		%Earring2.size_flags_vertical = anchors.back()
		
		anchors = Catalog.windrose_to_anchor[Bozo.Windrose.SW]
		%Earring1.size_flags_horizontal = anchors.front()
		%Earring1.size_flags_vertical = anchors.back()

func _on_value_changed():
	if data == null: return
	
	for _i in earrings.size():
		var earring = earrings[_i]
		earring.visible = _i < data.value

func apply_color() -> void:
	var hue_shift = Catalog.overlord_to_hue[trial.data.overlord.type]
	
	for earring in earrings:
		earring.material.set_shader_parameter("hue_shift", hue_shift)
