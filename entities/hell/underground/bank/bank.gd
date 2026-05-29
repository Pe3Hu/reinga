@tool
class_name Bank
extends PanelContainer


var data: BankData

@export var hell: Hell

@export var ambers: Array[TokenAmber]


func _ready() -> void:
	data = hell.world.data.hell.bank
	connect_datas()

func connect_datas() -> void:
	for _i in ambers.size():
		var amber = ambers[_i]
		var amber_data = data.ambers[_i]
		amber.data = amber_data

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			data.test_change()
