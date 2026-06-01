@tool
class_name Bank
extends PanelContainer


var data: BankData:
	set(value_):
		data = value_
		connect_datas()

@export var hell: Hell

@export var ambers: Array[TokenAmber]
@export var postures: Array[TokenPosture]

var type_to_token: Dictionary


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

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#data.test_change()
