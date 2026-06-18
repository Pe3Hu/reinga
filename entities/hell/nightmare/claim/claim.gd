class_name Claim
extends PanelContainer


var data: ClaimData:
	set(value_):
		data = value_
		connect_datas()

@export var trial: Trial
@export var sins: Array[TokenSin]

var type_to_token: Dictionary


func connect_datas() -> void:
	type_to_token.clear()
	
	for _i in data.sins.size():
		var sin_token = sins[_i]
		var sin_data = data.sins[_i]
		sin_token.data = sin_data
		type_to_token[sin_data.type] = sin_token

func apply_type() -> void:
	Helper.update_colors(%HeaderBackground, data.trial.overlord.type)
	%HeaderLabel.text = Catalog.trial_to_string[data.trial.type].capitalize()
