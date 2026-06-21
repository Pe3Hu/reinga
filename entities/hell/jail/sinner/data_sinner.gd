class_name SinnerData
extends Resource


@warning_ignore("unused_signal")
signal is_fused

var fate: FateData
var gyre: GyreData
var dream: DreamData
var soul: SoulData
var gate: GateData
var abyss: AbyssData
var cage: CageData


func _init(fate_: Bozo.Fate) -> void:
	fate = FateData.new(self, fate_)
	soul = SoulData.new(self)
	dream = DreamData.new(self)

func notify_fused() -> void:
	emit_signal("is_fused")
