class_name Sanctuary
extends Control


var data: SanctuaryData:
	set(value_):
		data = value_
		connect_datas()

@export var world: World

@export var miss: Modifier
@export var crit: Modifier
@export var megacrit: Modifier
@export var ultracrit: Modifier


@warning_ignore("shadowed_global_identifier")
@export var sin: Modifier
@export var amber: Modifier


func connect_datas() -> void:
	for type in Catalog.modifiers:
		var type_str = Catalog.modifier_to_string[type]
		var modifier = get(type_str)
		modifier.data = data.type_to_modifier[type]
	
	
	#miss.data = data.type_to_modifier[Bozo.Modifier.MISS]
	#crit.data = data.type_to_modifier[Bozo.Modifier.CRIT]
	#megacrit.data = data.type_to_modifier[Bozo.Modifier.MEGACRIT]
	#ultracrit.data = data.type_to_modifier[Bozo.Modifier.ULTRACRIT]

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
