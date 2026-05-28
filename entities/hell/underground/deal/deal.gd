@tool
class_name Deal
extends PanelContainer


@export var sin_token: TokenSin
@export var amber_token: TokenAmber

var data: DealData:
	set(value_):
		data = value_
		update_tokens()


func update_tokens() -> void:
	sin_token.type = data.sin_data.type
	sin_token.value = data.sin_data.value
	amber_token.type = data.amber_data.type
	amber_token.value = data.amber_data.value
