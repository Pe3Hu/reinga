class_name Tax
extends PanelContainer


var data: TaxData:
	set(value_):
		data = value_
		connect_datas()
		update_colors()

@export var sins: Array[TokenSin]

var type_to_token: Dictionary


func connect_datas() -> void:
	#%Background.material = 
	type_to_token.clear()
	
	for _i in data.sins.size():
		var sin_token = sins[_i]
		var sin_data = data.sins[_i]
		sin_token.data = sin_data
		type_to_token[sin_data.type] = sin_token

func update_colors() -> void:
	var hue = Catalog.overlord_to_hue[data.flame.trial.overlord]
	var color_a: Color = Color(Catalog.overlord_to_pallete[0])
	var color_b: Color = Color(Catalog.overlord_to_pallete[1])
	var color_c: Color = Color(Catalog.overlord_to_pallete[2])
	color_a.h += hue
	color_b.h += hue
	color_c.h += hue
	%Background.material.set_shader_parameter("colorA", color_a)
	%Background.material.set_shader_parameter("colorB", color_b)
	%Background.material.set_shader_parameter("colorC", color_c)
