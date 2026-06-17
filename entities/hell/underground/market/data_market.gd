class_name MarketData
extends Resource


@warning_ignore("unused_signal")
signal order_changed

var hell: HellData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.MARKET
var deals: Array[DealData]
var type_to_deal: Dictionary

var amber_options: Array[Bozo.Amber]
var sin_options: Array[Bozo.Sin]
var closeds: Array[DealData]
var last_deal: DealData


func _init(hell_: HellData) -> void:
	hell = hell_
	init_deals()

func init_deals() -> void:
	for sin_type in Catalog.sins:
		add_deal(sin_type)
	
	deals.shuffle()

func add_deal(sin_type_: Variant) -> void:
	var modifier = Bozo.Modifier.SIN
	var min_value = Helper.get_modifier_rank_value(modifier) - Catalog.deal_scope
	var max_value = Helper.get_modifier_rank_value(modifier) + Catalog.deal_scope
	var in_value = randi_range(min_value, max_value)
	var sin_data = SinData.new(sin_type_, in_value)
	var amber_type = pull_ember_type()
	
	while amber_type == sin_type_:
		amber_type = pull_ember_type()
	
	modifier = Bozo.Modifier.AMBER
	min_value = Helper.get_modifier_rank_value(modifier) - Catalog.deal_scope
	max_value = Helper.get_modifier_rank_value(modifier) + Catalog.deal_scope
	var out_value = randi_range(min_value, max_value)
	var amber_data = AmberData.new(amber_type, out_value)
	var deal = DealData.new(self, sin_data, amber_data)
	deals.append(deal)
	type_to_deal[sin_type_] = deal

func refill_ember_options() -> void:
	amber_options.append_array(Catalog.deal_ambers)
	amber_options.shuffle()

func pull_ember_type() -> Bozo.Amber:
	if amber_options.is_empty():
		refill_ember_options()
	return amber_options.pop_back()

func refill_closed_deals() -> void:
	last_deal = deals.pop_back()
	closeds.append(last_deal)
	closeds.shuffle()
	
	while !closeds.is_empty():
		var deal = closeds.pop_back()
		create_new_deal(deal)
	
	emit_signal("order_changed")

func create_new_deal(deal_: DealData) -> void:
	deals.push_front(deal_)
	
	var modifier = Bozo.Modifier.SIN
	#var rank = hell.world.throne.type_to_overlord[Bozo.Overlord.VIRELLO].rank
	var min_value = Helper.get_modifier_rank_value(modifier) - Catalog.deal_scope #Catalog.modifier_to_rank_to_value[Bozo.Modifier.SIN][rank] - Catalog.deal_scope
	var max_value = Helper.get_modifier_rank_value(modifier) + Catalog.deal_scope#Catalog.modifier_to_rank_to_value[Bozo.Modifier.SIN][rank] + Catalog.deal_scope
	deal_.sin_data.value = randi_range(min_value, max_value)
	
	modifier = Bozo.Modifier.AMBER
	min_value = Helper.get_modifier_rank_value(modifier) - Catalog.deal_scope#Catalog.modifier_to_rank_to_value[Bozo.Modifier.AMBER][rank] - Catalog.deal_scope
	max_value = Helper.get_modifier_rank_value(modifier) + Catalog.deal_scope#Catalog.modifier_to_rank_to_value[Bozo.Modifier.AMBER][rank] + Catalog.deal_scope
	deal_.amber_data.value = randi_range(min_value, max_value)
	
	sin_options.clear()
	var sin_type = pull_sin_type(deal_)
	
	while deal_.amber_data.type == sin_type:
		sin_type = pull_sin_type(deal_)

func pull_sin_type(deal_: DealData) -> Bozo.Sin:
	if sin_options.is_empty():
		refill_sin_options(deal_)
	return sin_options.pop_back()

func refill_sin_options(deal_: DealData) -> void:
	sin_options.append_array(Catalog.sins)
	var amber_sin = Catalog.amber_to_sin[deal_.amber_data.type]
	sin_options.erase(amber_sin)
	sin_options.append(deal_.sin_data.type)
	sin_options.shuffle()
