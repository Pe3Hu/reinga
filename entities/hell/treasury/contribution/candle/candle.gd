@tool
class_name Candle
extends Control


var data: CandleData:
	set(value_):
		data = value_
		apply_data_info()

@export var contribution: Contribution

@export var active_border: ColorRect


func _ready():
	active_border.pivot_offset = active_border.size / 2.0
	active_border.material = ShaderMaterial.new()

func apply_data_info() -> void:
	data.contribution.windrose_changed.connect(_on_windrose_changed)
	data.is_selected_changed.connect(_is_selected_changed)
	_on_windrose_changed()

func _on_windrose_changed() -> void:
	if data.is_simple:
		%TextureRect.texture = load("res://entities/hell/treasury/contribution/candle/images/%d.png" % data.contribution.type)
		active_border.material.shader = load("uid://dvh5x2623erk2")
		return
	
	if data.type == Bozo.Windrose.ESWN:
		active_border.rotation_degrees = 0.0
		active_border.material.shader = load("uid://b0h2a2506yvi1")
		return
	else:
		active_border.material.shader = load("uid://cpdpc4c7cty0b")
	
	var angle_deg := float(data.type % 8) * 45.0
	active_border.rotation_degrees = angle_deg

func _is_selected_changed() -> void:
	active_border.visible = data.is_selected

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			contribution.treasury.undo_resort()
