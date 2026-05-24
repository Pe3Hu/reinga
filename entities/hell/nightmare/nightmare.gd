class_name Nightmare
extends PanelContainer


var data: NightmareData = NightmareData.new()

@export var trials: Array[Trial]

@export var hell: Hell
@export var lock_button: Button


func _ready() -> void:
	for _i in data.trials.size():
		var trial = trials[_i]
		trial.data = data.trials[_i]

func awaken_dreams() -> void:
	for cage in hell.jail.cages:
		cage.cloak.dream.dissolve_tokens()
	
	var desires: Dictionary
	
	for sinner in hell.tribunal.actual.sinners:
		sinner.dream.update_desires(desires)
	
	for trial in trials:
		var desire = Catalog.trial_to_desire[trial.type]
		if desires.has(desire):
			var heat_value = desires[desire]
			hell.volcano.burst_splash(trial.flame.progression, heat_value)

func _on_lock_button_pressed() -> void:
	lock_button.visible = false
	hell.jail.is_locked = true
	hell.treasury.hide_not_selected_tributes()
	hell.volcano.burst_eruption()
