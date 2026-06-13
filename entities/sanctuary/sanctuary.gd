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

@export var genius: Modifier
@export var exile: Modifier
@export var layman: Modifier
@export var leader: Modifier
@export var parent: Modifier
@export var child: Modifier

@export var ballet: Modifier
@export var puppetry: Modifier
@export var opera: Modifier

@export var trust: Modifier
@export var hope: Modifier


@export var taxs: Array[Tax]


func connect_datas() -> void:
	for type in Catalog.modifiers:
		var type_str = Catalog.modifier_to_string[type]
		var modifier = get(type_str)
		modifier.data = data.type_to_modifier[type]
	
	for _i in taxs.size():
		var tax = taxs[_i]
		var tax_data = data.taxs[_i]
		tax.data = tax_data

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
