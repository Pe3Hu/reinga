class_name Claim
extends MarginContainer


var data: ClaimData:
	set(value_):
		data = value_
		connect_datas()

@export var trial: Trial
@export var sins: Array[TokenSin]


func connect_datas() -> void:
	for _i in data.sins.size():
		var sin_token = sins[_i]
		var sin_data = data.sins[_i]
		sin_token.data = sin_data
