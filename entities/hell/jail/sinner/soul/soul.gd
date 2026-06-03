class_name Soul
extends MarginContainer


var data: SoulData:
	set(value_):
		data = value_
		connect_datas()
@export var sinner: Sinner

var traits: Array[Trait]

@export var background: ColorRect
@export var fear: Trait
@export var horror: Trait
@export var guilt: Trait
@export var repose: Trait

var type: Bozo.Tooltip = Bozo.Tooltip.SOUL


func _ready() -> void:
	traits = [
		fear,
		horror,
		guilt,
		repose
	]

func connect_datas() -> void:
	fear.data = data.fear
	horror.data = data.horror
	guilt.data = data.guilt
	repose.data = data.repose
