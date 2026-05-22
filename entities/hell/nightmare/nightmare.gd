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


func _on_lock_button_pressed() -> void:
	lock_button.visible = false
	hell.jail.is_locked = true
	hell.treasury.hide_not_selected_tributes()
	hell.volcano.burst()
