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
			fate.type = data.fate
			soul.connect_datas()
			cage.cloak.dream.data = data.dream
		else:
			%Header.visible = false

var type: Bozo.Tooltip = Bozo.Tooltip.SINNER
