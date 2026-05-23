@tool
class_name Trial
extends PanelContainer


var data: TrialData:
	set(value_):
		data = value_
		init_sin_tokens()

@export var type: Bozo.Trial:
	set(value_):
		type = value_
		
		%HeaderColorRect.color = Catalog.trial_to_color[type]
		%HeaderLabel.text = Catalog.trial_to_string[type].capitalize()
		attitude.update_trial()

@export var sins: Array[TokenSin]
@export var attitude: Attitude

var sin_to_token: Dictionary


func init_sin_tokens() -> void:
	for _i in data.sins.size():
		var token = sins[_i]
		token.value = data.sins[_i].value
		token.type = data.sins[_i].type
		sin_to_token[token.type] = token

func update_sins() -> void:
	pass
