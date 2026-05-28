class_name MarketData
extends Resource


var deals: Array[DealData]
var type_to_deal: Dictionary
var level: int = 1


func _init() -> void:
	init_deals()

func init_deals() -> void:
	for sin_type in Catalog.sins:
		add_deal(sin_type)
	
	deals.shuffle()

func add_deal(type_: Variant) -> void:
	var in_value = randi_range(Catalog.market_in_range[level].front(), Catalog.market_in_range[level].back())
	var sin_data = SinData.new(type_, in_value)
	var out_value = randi_range(Catalog.market_out_range[level].front(), Catalog.market_out_range[level].back())
	var amber_data = AmberData.new(type_, out_value)
	var deal = DealData.new(sin_data, amber_data)
	deals.append(deal)
	type_to_deal[type_] = deal
