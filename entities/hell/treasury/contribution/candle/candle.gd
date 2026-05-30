@tool
class_name Candle
extends Control


var data: ContributionData:
	set(value_):
		data = value_
		apply_data_info()

@export var contribution: Contribution

@onready var rect: ColorRect = %ColorRect

var is_simple: bool = true


func _ready():
	rect.pivot_offset = rect.size / 2.0
	rect.material = ShaderMaterial.new()

func apply_data_info() -> void:
	data.windrose_changed.connect(_on_windrose_changed)
	_on_windrose_changed()

func _on_windrose_changed() -> void:
	if is_simple:
		%TextureRect.texture = load("res://entities/hell/treasury/contribution/candle/images/%d.png" % data.type)
		return
	
	if data.type == Bozo.Windrose.ESWN:
		rect.rotation_degrees = 0.0
		rect.material.shader = load("uid://b0h2a2506yvi1")
		return
	else:
		rect.material.shader = load("uid://cpdpc4c7cty0b")
	
	var angle_deg := float(data.type % 8) * 45.0
	rect.rotation_degrees = angle_deg

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			contribution.treasury.undo_resort()
