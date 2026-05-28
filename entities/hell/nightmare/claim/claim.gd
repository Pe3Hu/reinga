class_name Claim
extends MarginContainer


@export var trial: Trial
@export var sins: Array[TokenSin]


var sin_to_token: Dictionary


func init_sin_tokens() -> void:
	for _i in trial.data.claim.sins.size():
		var token = sins[_i]
		token.value = trial.data.claim.sins[_i].value
		token.type = trial.data.claim.sins[_i].type
		sin_to_token[token.type] = token

func refill() -> void:
	for sin_data in trial.data.claim.sins:
		var token = sin_to_token[sin_data.type]
		token.value += sin_data.value
	
	trial.tribute.calc_half()
