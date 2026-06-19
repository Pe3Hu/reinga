@tool
extends Control
class_name Sinner


@export var cage: Cage

@export var faction: TokenFaction
@export var soul: Soul
@export var fate: Fate

var data: SinnerData:
	set(value_):
		data = value_
		
		if data != null:
			%Header.visible = true
			fate.data = data.fate
			faction.data = data.fate.faction
			soul.data = data.soul
			cage.cloak.dream.data = data.dream
		else:
			%Header.visible = false

var type: Bozo.Tooltip = Bozo.Tooltip.SINNER


func connect_signals() -> void:
	if !data.is_fused.is_connected(_on_is_fused):
		data.is_fused.connect(_on_is_fused)

func _on_is_fused() -> void:
	cage.cloak.dream._on_desires_changed()
	soul.doom.connect_datas()

func apply_phase_visiblity() -> void:
	cage.apply_cage_visibility()
