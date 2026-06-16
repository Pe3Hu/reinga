class_name HellData
extends Resource


var world: WorldData
var nightmare: NightmareData = NightmareData.new(self)
var jail: JailData
var treasury: TreasuryData
var market

var bank: BankData = BankData.new(self)


func _init(world_: WorldData) -> void:
	world = world_
	jail = JailData.new(self)
	treasury = TreasuryData.new(self)
	market = MarketData.new(self)
