@tool
class_name Deal
extends PanelContainer


var data: DealData:
	set(value_):
		data = value_
		connect_datas()

@export var sin_token: TokenSin
@export var amber_token: TokenAmber



func connect_datas() -> void:
	sin_token.data = data.sin_data
	amber_token.data = data.amber_data
