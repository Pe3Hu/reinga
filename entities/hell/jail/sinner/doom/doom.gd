class_name Doom
extends PanelContainer


var data: DoomData:
	set(value_):
		data = value_
		connect_datas()

@export var soul: Soul
@export var family: TokenOmen
@export var destiny: TokenOmen


func _ready() -> void:
	data = DoomData.new()

func connect_datas() -> void:
	family.data = data.family
	destiny.data = data.destiny
