class_name DealData
extends Resource


@warning_ignore("unused_signal")
signal is_completed

var market: MarketData
var sin_data: SinData
var amber_data: AmberData


func _init(market_: MarketData, sin_: SinData, amber_: AmberData) -> void:
	market = market_
	sin_data = sin_
	amber_data = amber_
	sin_.deal = self


func set_as_closed() -> void:
	market.deals.erase(self)
	market.closeds.append(self)
