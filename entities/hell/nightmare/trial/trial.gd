@tool
class_name Trial
extends PanelContainer


var data: TrialData:
	set(value_):
		data = value_
		connect_datas()

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
	
	apply_type()

func apply_type() -> void:
	%HeaderColorRect.color = Catalog.trial_to_color[data.type]
	%HeaderLabel.text = Catalog.trial_to_string[data.type].capitalize()
	attitude.update_trial()
	tribute.icon.modulate = Catalog.trial_to_color[data.type]
	flame.icon.modulate = Catalog.trial_to_color[data.type]
