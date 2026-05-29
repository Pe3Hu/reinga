class_name MarketData
extends Resource


var hell: HellData
var deals: Array[DealData]
var type_to_deal: Dictionary
var level: int = 1

var amber_options: Array[Bozo.Amber]




func _init(hell_: HellData) -> void:
	hell = hell_
	init_deals()

func init_deals() -> void:
	
	for sin_type in Catalog.sins:
		add_deal(sin_type)
	
	deals.shuffle()

func add_deal(sin_type_: Variant) -> void:
	
	var in_value = randi_range(Catalog.market_in_range[level].front(), Catalog.market_in_range[level].back())
	var sin_data = SinData.new(sin_type_, in_value)
	var amber_type = pull_ember_type()
	while amber_type == sin_type_:
		amber_type = pull_ember_type()
	var out_value = randi_range(Catalog.market_out_range[level].front(), Catalog.market_out_range[level].back())
	var amber_data = AmberData.new(amber_type, out_value)
	var deal = DealData.new(sin_data, amber_data)
	deals.append(deal)
	type_to_deal[sin_type_] = deal

func refill_ember_options() -> void:
	amber_options.append_array(Catalog.deal_ambers)
	amber_options.shuffle()

func pull_ember_type() -> Bozo.Amber:
	if amber_options.is_empty():
		refill_ember_options()
	return amber_options.pop_back()
