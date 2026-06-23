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
@export var bless_seal: Seal
@export var curse_seal: Seal


func connect_datas() -> void:
	attitude.data = data.attitude
	tribute.data = data.tribute
	flame.data = data.flame
	claim.data = data.claim
	bless_seal.data = data.crown.type_to_seal[Bozo.Seal.BLESS]
	curse_seal.data = data.crown.type_to_seal[Bozo.Seal.CURSE]

func apply_type() -> void:
	claim.apply_type()
	Helper.update_colors(tribute.icon, data.overlord.type)
	Helper.update_colors(flame.icon, data.overlord.type)
