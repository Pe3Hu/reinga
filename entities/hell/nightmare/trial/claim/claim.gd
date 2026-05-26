class_name Claim
extends MarginContainer


@export var trial: Trial
@export var sins: Array[TokenSin]


var sin_to_token: Dictionary


func init_sin_tokens() -> void:
	for _i in trial.data.sins.size():
		var token = sins[_i]
		token.value = trial.data.sins[_i].value
		token.type = trial.data.sins[_i].type
		sin_to_token[token.type] = token
