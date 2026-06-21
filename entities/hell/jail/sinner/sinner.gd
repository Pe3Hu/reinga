@tool
extends Control
class_name Sinner


var data: SinnerData:
	set(value_):
		data = value_
		
		if data != null:
			%Header.visible = true
			connect_datas()
			connect_signals()
		else:
			%Header.visible = false

@export var cage: Cage

@export var faction: TokenFaction
@export var soul: Soul
@export var fate: Fate

var type: Bozo.Tooltip = Bozo.Tooltip.SINNER


func connect_datas() -> void:
	fate.data = data.fate
	faction.data = data.fate.faction
	soul.data = data.soul
	cage.cloak.dream.data = data.dream

func connect_signals() -> void:
	if data == null:
		return
	if !data.is_fused.is_connected(_on_is_fused):
		data.is_fused.connect(_on_is_fused)

func _on_is_fused() -> void:
	if cage.cloak.dream.data:
		cage.cloak.dream._on_desires_changed()
	soul.connect_datas()
	if Scope.layer == Bozo.Layer.MUSEUM:
		soul.show_all()

func apply_phase_visiblity() -> void:
	cage.apply_cage_visibility()
