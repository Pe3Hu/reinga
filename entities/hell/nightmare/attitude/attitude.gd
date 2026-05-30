@tool 
class_name Attitude
extends PanelContainer


var data: AttitudeData:
	set(value_):
		data = value_
		apply_data_info()

@export var trial: Trial
@export var icon: TextureRect


@export var bowls: Array[Bowl]




func start_repletion() -> void:
	var shift = Catalog.half_to_shift[trial.tribute.data.type]
	data.shifts.append(shift)
	trial.nightmare.repletion_attitudes.append(self)
	apply_shifts()

func apply_shifts() -> void:
	if data.shifts.is_empty(): 
		trial.nightmare.end_attitude_repletion(self)
		data.ban_type = Bozo.Attitude.NONE
		return
	var shift = data.shifts.pop_back()
	var factor = Catalog.attitude_to_factor[data.type]
	var bowl: Bowl = %PlusBowl
	
	if shift < 0:
		bowl = %MinusBowl
	
	var limit_step = Catalog.BOWL_LIMIT / factor
	var current_step = bowl.data.value / factor
	var step_size = min(limit_step - current_step, abs(shift))
	var new_value = (current_step + step_size) * factor
	shift -= sign(shift) * step_size
	
	if abs(shift) != 0:
		data.shifts.append(shift)
	
	var duration = step_size * Catalog.REPLETION_TICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(bowl.data, "value", new_value, duration)
	tween.tween_callback(apply_shifts)

func drain_bowl(bowl_: Bowl) -> void:
	for bowl in bowls:
		bowl.reset()
	
	if data.ban_type == Bozo.Attitude.NONE:
		data.type = Catalog.attitude_to_blob_to_attitude[data.type][bowl_.data.type]
		data.ban_type = Catalog.attitude_to_blob_to_attitude[data.type][bowl_.data.type]

func apply_data_info() -> void:
	data.type_changed.connect(_on_type_changed)
	trial.data.type_changed.connect(_on_trial_type_changed)
	_connect_bowls()
	_on_type_changed()
	_on_trial_type_changed()

func _connect_bowls() -> void:
	%MinusBowl.data = data.blob_to_bowls[Bozo.Blob.MINUS]
	%PlusBowl.data = data.blob_to_bowls[Bozo.Blob.PLUS]

func _on_type_changed() -> void:
	if data.type == 0: return
	icon.texture = load("res://entities/hell/nightmare/attitude/images/%s.png" % Catalog.attitude_to_string[data.type]) 

func _on_trial_type_changed() -> void:
	if trial.data.type == 0: return
	icon.modulate = Catalog.trial_to_color[trial.data.type]
