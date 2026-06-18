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
	Helper.update_colors(%Background, data.flame.trial.overlord.type)
