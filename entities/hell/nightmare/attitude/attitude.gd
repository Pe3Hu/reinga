@tool 
class_name Attitude
extends PanelContainer


var data: AttitudeData:
	set(value_):
		data = value_
		connect_datas()
		apply_data_info()

@export var trial: Trial
@export var crown_icon: TextureRect
@export var face_icon: TextureRect


@export var bowls: Array[Bowl]



func connect_datas() -> void:
	%MinusBowl.data = data.blob_to_bowls[Bozo.Blob.MINUS]
	%PlusBowl.data = data.blob_to_bowls[Bozo.Blob.PLUS]

func apply_data_info() -> void:
	data.type_changed.connect(_on_type_changed)
	trial.data.type_changed.connect(_on_trial_type_changed)
	_on_type_changed()
	_on_trial_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	face_icon.texture = load("res://entities/hell/nightmare/attitude/images/face/%s.png" % Catalog.attitude_to_string[data.type]) 
	crown_icon.texture = load("res://entities/hell/nightmare/attitude/images/crown/%s.png" % Catalog.attitude_to_string[data.type]) 
	face_icon.material.set_shader_parameter("mask_texture", load("res://entities/hell/nightmare/attitude/images/face/%s.png" % Catalog.attitude_to_string[data.type]))
	crown_icon.material.set_shader_parameter("mask_texture", load("res://entities/hell/nightmare/attitude/images/crown/%s.png" % Catalog.attitude_to_string[data.type]))


func _on_trial_type_changed() -> void:
	if trial.data.type == 0: return
	Helper.update_colors(face_icon, trial.data.overlord.type)
	Helper.update_colors(crown_icon, trial.data.overlord.type)

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
		data.privilege_type = data.type
		data.type = Catalog.attitude_to_blob_to_attitude[data.type][bowl_.data.type]
		data.ban_type = Catalog.attitude_to_blob_to_attitude[data.type][bowl_.data.type]
		add_decree(bowl_)
		
		if data.type == Bozo.Attitude.INDIFFERENCE and (data.privilege_type == Bozo.Attitude.RAPTURE or data.privilege_type == Bozo.Attitude.SCORN):
			data.trial.nightmare.privilege_attitudes.append(data)
		else:
			data.privilege_type = Bozo.Attitude.NONE

func add_decree(bowl_: Bowl) -> void:
	var blob = bowl_.data.type
	var overlord = trial.data.overlord
	data.trial.nightmare.hell.world.herald.add_decree(overlord, blob)

func apply_privilege() -> void:
	#var flame_shifts: Array[int]
	var progression = trial.flame.progression
	#var total_shift = 0
	var flame_shift = progression.data.current_value
	var next_level = data.trial.flame.level
	
	if data.privilege_type == Bozo.Attitude.SCORN: 
		next_level = max(1, data.trial.flame.level - 1)
		flame_shift += Catalog.flame_to_heat[next_level]
	
	var duration = await trial.nightmare.hell.volcano.burst_splash(progression, flame_shift, -1)
	
	await get_tree().create_timer(duration).timeout
	trial.claim.data.apply_privilege()

#func tween_apply_privilege(data.privilege_type: Bozo.Attitude) -> void:
	#var flame_shifts: Array[int]
	#var progression = data.trial.flame.progression
	#var total_shift = 0
	#var flame_shift = -progression.current_value
	#flame_shifts.append(flame_shift)
	#
	#if data.privilege_type == Bozo.Attitude.SCORN:
		#var previous_level = min(1, data.trial.flame.level - 1)
		#flame_shift = -Catalog.flame_to_heat[previous_level]
		#flame_shifts.append(flame_shift)
	#
	#for shift in flame_shifts:
		#total_shift += abs(shift)
	#
	#var durations = []
	#
	#for shift in flame_shifts: 
		#var duration = Gear.privileges[Gear.tempo] * abs(shift) / total_shift *5
		#durations.append(duration)
	#
	#var tween = create_tween()
	#tween.tween_property(progression, "current_value", 0, durations.front())
	#await tween.finished
	#data.trial.flame.level -= 1
	##current_value = limit_value + current_value
	#
	#if durations.size() > 1:
		#tween = create_tween()
		#tween.tween_property(progression, "current_value", progression.limit_value + flame_shifts.back(), durations.back())
