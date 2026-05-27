@tool
class_name Trial
extends PanelContainer


@export var nightmare: Nightmare

var data: TrialData:
	set(value_):
		data = value_
		claim.init_sin_tokens()

@export var type: Bozo.Trial:
	set(value_):
		type = value_
		
		%HeaderColorRect.color = Catalog.trial_to_color[type]
		%HeaderLabel.text = Catalog.trial_to_string[type].capitalize()
		attitude.update_trial()
		tribute.icon.modulate = Catalog.trial_to_color[type]
		flame.icon.modulate = Catalog.trial_to_color[type]

@export var attitude: Attitude
@export var tribute : Tribute
@export var flame: Flame
@export var claim: Claim
