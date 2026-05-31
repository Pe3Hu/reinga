class_name Shelter
extends PanelContainer


var data: ShelterData:
	set(value_):
		data = value_
		connect_datas()

@export var ultracrit: Modifier
@export var megacrit: Modifier
@export var crit: Modifier
@export var misscrit: Modifier


func connect_datas() -> void:
	ultracrit.data = data.type_to_modifier[Bozo.Modifier.ULTRACRIT]
	megacrit.data = data.type_to_modifier[Bozo.Modifier.MEGACRIT]
	crit.data = data.type_to_modifier[Bozo.Modifier.CRIT]
	misscrit.data = data.type_to_modifier[Bozo.Modifier.MISS]
