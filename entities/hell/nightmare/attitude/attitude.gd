@tool 
class_name Attitude
extends PanelContainer


@export var trial: Trial
@export var icon: TextureRect

@export var type: Bozo.Attitude:
	set(value_):
		type = value_
		if is_node_ready():
			icon.texture = load("res://entities/hell/nightmare/attitude/images/%s.png" % Catalog.attitude_to_string[type]) 

@export var bowls: Array[Bowl]
var shifts: Array[int]
var ban_type: Bozo.Attitude


func _ready() -> void:
	for bowl in bowls:
		bowl.side = bowl.side

func update_trial() -> void:
	icon.modulate = Catalog.trial_to_color[trial.type]
	
	for bowl in bowls:
		bowl.trial = trial.type

func start_repletion() -> void:
	var shift = Catalog.half_to_shift[trial.tribute.type]
	shifts.append(shift)
	trial.nightmare.repletion_attitudes.append(self)
	apply_shifts()

func apply_shifts() -> void:
	if shifts.is_empty(): 
		trial.nightmare.end_attitude_repletion(self)
		ban_type = Bozo.Attitude.NONE
		return
	var shift = shifts.pop_back()
	var factor = Catalog.attitude_to_factor[type]
	var bowl: Bowl = %PlusBowl
	
	if shift < 0:
		bowl = %MinusBowl
	
	var limit_step = Catalog.BOWL_LIMIT / factor
	var current_step = bowl.value / factor
	var step_size = min(limit_step - current_step, abs(shift))
	var new_value = (current_step + step_size) * factor
	shift -= sign(shift) * step_size
	
	if abs(shift) != 0:
		shifts.append(shift)
	
	var duration = step_size * Catalog.REPLETION_TICK
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(bowl, "value", new_value, duration)
	tween.tween_callback(apply_shifts)

func drain_bowl(bowl_: Bowl) -> void:
	for bowl in bowls:
		bowl.reset()
	
	if ban_type == Bozo.Attitude.NONE:
		type = Catalog.attitude_to_blob_to_attitude[type][bowl_.type]
		ban_type = Catalog.attitude_to_blob_to_attitude[type][bowl_.type]
