class_name Market
extends PanelContainer


var data = MarketData.new()

@export var hell: Hell
@export var deals: Array[Deal]


func _ready() -> void:
	connect_datas()

func connect_datas() -> void:
	for _i in data.deals.size():
		var deal_data = data.deals[_i]
		var deal = deals[_i]
		deal.data = deal_data
