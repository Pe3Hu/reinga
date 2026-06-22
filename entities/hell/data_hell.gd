class_name HellData
extends Resource


var world: WorldData
var nightmare: NightmareData
var jail: JailData
var treasury: TreasuryData
var market: MarketData
var bank: BankData


func _init(world_: WorldData) -> void:
	world = world_
	nightmare = NightmareData.new(self)
	jail = JailData.new(self)
	treasury = TreasuryData.new(self)
	market = MarketData.new(self)
	bank = BankData.new(self)
