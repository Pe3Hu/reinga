@tool
class_name Deal
extends PanelContainer



var data: DealData:
	set(value_):
		data = value_
		connect_datas()

@export var market: Market
@export var sin_token: TokenSin
@export var amber_token: TokenAmber



func connect_datas() -> void:
	update()
	data.is_completed.connect(_on_is_completed)

func _on_is_completed() -> void:
	market.hell.volcano.deal_burst(self)
	data.set_as_closed()

func update() -> void:
	sin_token.data = data.sin_data
	amber_token.data = data.amber_data
	
