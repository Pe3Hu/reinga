@tool
class_name Bank
extends PanelContainer


var data: BankData:
	set(value_):
		data = value_
		connect_datas()

@export var hell: Hell

@export var ambers: Array[TokenAmber]


func connect_datas() -> void:
	for _i in ambers.size():
		var amber = ambers[_i]
		var amber_data = data.ambers[_i]
		amber.data = amber_data

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			data.test_change()
