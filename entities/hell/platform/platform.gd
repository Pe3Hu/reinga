class_name Platform
extends PanelContainer


var data: PlatformData:
	set(value_):
		data = value_
		connect_datas()


@export var hell: Hell
@export var cells: ColorRect
@export var active_cage: MarginContainer

@export var operas: Array[Spectacle]
@export var puppetrys: Array[Spectacle]
@export var ballets: Array[Spectacle]
@export var spectacles: Array[Spectacle]


func connect_datas() -> void:
	for _i in spectacles.size():
		var spectacle = spectacles[_i]
		var spectacle_data = data.spectacles[_i]
		spectacle.data = spectacle_data
