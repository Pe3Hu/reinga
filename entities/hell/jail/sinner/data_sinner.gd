class_name SinnerData
extends Resource



var fate: FateData
var gyre: GyreData
var dream: DreamData
var soul: SoulData
var gate: GateData


func _init(fate_: Bozo.Fate) -> void:
	fate = FateData.new(self, fate_)
	soul = SoulData.new(self)
	dream = DreamData.new(self)
