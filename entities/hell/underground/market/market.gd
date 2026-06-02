class_name Market
extends PanelContainer


var data: MarketData:
	set(value_):
		data = value_
		connect_datas()

@export var hell: Hell
@export var deals: Array[Deal]

var type_to_token: Dictionary
var type_to_amber: Dictionary



func connect_datas() -> void:
	for _i in data.deals.size():
		var deal_data = data.deals[_i]
		var deal = deals[_i]
		deal.data = deal_data
		type_to_token[deal_data.sin_data.type] = deal.sin_token
		type_to_amber[deal_data.amber_data.type] = deal.amber_token
	
	data.order_changed.connect(reoder_deals)
	reoder_deals()

func reoder_deals() -> void:
	for _i in range(data.deals.size() -1, -1, -1):
		var deal_data = data.deals[_i]
		var deal = type_to_amber[deal_data.amber_data.type].deal
		%Deals.move_child(deal, _i)
		deal.update()
