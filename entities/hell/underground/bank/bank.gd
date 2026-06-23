@tool
class_name Bank
extends PanelContainer


var data: BankData:
	set(value_):
		data = value_
		connect_datas()
		connect_signals()

@export var hell: Hell

@export var ambers: Array[TokenAmber]
@export var postures: Array[TokenPosture]
@export var lock_button: CustomButton

var type_to_token: Dictionary

var active_safe: Safe:
	set(value_):
		if active_safe:
			active_safe.deactivate()
		
		active_safe = value_
		
		if active_safe != null:
			active_safe.activate()


func connect_datas() -> void:
	for _i in ambers.size():
		var amber = ambers[_i]
		var amber_data = data.ambers[_i]
		amber.data = amber_data
		type_to_token[amber_data.type] = amber
	
	for _i in postures.size():
		var posture = postures[_i]
		var posture_data = data.postures[_i]
		posture.data = posture_data
		type_to_token[posture_data.type] = posture
		posture.visible = true

func connect_signals() -> void:
	data.sacrifice_received.connect(_on_sacrifice_received)

func reset() -> void:
	lock_button.hide_me()

func _on_sacrifice_received() -> void:
	if data.sacrifice == null: return
	var amber_datas = data.get_sacrifice_ambers()
	var tween = create_tween()
	tween.set_parallel(true)
	
	for amber_data in amber_datas:
		var sacrifice_time = randf_range(0.8, 1.2) * Gear.spectacle_ambers[Gear.tempo]
		tween.tween_property(amber_data, "value", amber_data.next_value, sacrifice_time)
	
	tween.tween_callback(data.reset_sacrifice)

func forget_safe() -> void:
	if active_safe == null: return
	active_safe.deactivate()
	active_safe = null
