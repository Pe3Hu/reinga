@tool
class_name Candle
extends Control



@export var windrose: Bozo.Windrose =  Bozo.Windrose.NONE:
	set(value_):
		windrose = value_
		apply_windrose()

@onready var rect: ColorRect = %ColorRect


func _ready():
	rect.pivot_offset = rect.size / 2.0
	rect.material = ShaderMaterial.new()

func apply_windrose():
	if windrose == Bozo.Windrose.ESWN:
		rect.rotation_degrees = 0.0
		rect.material.shader = load("uid://b0h2a2506yvi1")
		return
	else:
		rect.material.shader = load("uid://cpdpc4c7cty0b")
	
	var angle_deg := float(windrose % 9) * 45.0
	rect.rotation_degrees = angle_deg
