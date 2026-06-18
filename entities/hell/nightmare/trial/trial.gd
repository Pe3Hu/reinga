@tool
class_name Trial
extends PanelContainer


var data: TrialData:
	set(value_):
		data = value_
		connect_datas()
		apply_type()

@export var nightmare: Nightmare

@export var attitude: Attitude
@export var tribute : Tribute
@export var flame: Flame
@export var claim: Claim


func connect_datas() -> void:
	attitude.data = data.attitude
	tribute.data = data.tribute
	flame.data = data.flame
	claim.data = data.claim

func apply_type() -> void:
	claim.apply_type()
	Helper.update_colors(tribute.icon, data.overlord.type)
	Helper.update_colors(flame.icon, data.overlord.type)
