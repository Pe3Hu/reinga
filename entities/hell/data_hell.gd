class_name HellData
extends Resource


var world: WorldData
var nightmare: NightmareData = NightmareData.new(self)
var jail: JailData = JailData.new(self)

var bank: BankData = BankData.new(self)
var shelter: ShelterData = ShelterData.new(self)
var market: MarketData = MarketData.new(self)


func _init(world_: WorldData) -> void:
	world = world_
