class_name BankData
extends Resource


@warning_ignore("unused_signal")
signal sacrifice_received

var hell: HellData
var ambers: Array[AmberData]
var postures: Array[PostureData]
var sacrifice: SacrificeData

var tooltip: Bozo.Tooltip = Bozo.Tooltip.BANK
var type_to_amber: Dictionary
var type_to_posture: Dictionary


#region init
func _init(hell_: HellData) -> void:
	hell = hell_
	
	init_ambers()
	init_postures()

func init_ambers() -> void:
	for type in Catalog.ambers:
		add_amber(type)

func add_amber(type_: Bozo.Amber) -> void:
	var amber = AmberData.new(type_)
	ambers.append(amber)
	type_to_amber[type_] = amber
	amber.always_visible = true

func init_postures() -> void:
	for type in Catalog.postures:
		add_posture(type)

func add_posture(type_: Bozo.Posture) -> void:
	var default_value = 0
	var posture = PostureData.new(type_, default_value)
	postures.append(posture)
	type_to_posture[type_] = posture
#endregion

func get_sacrifice_ambers() -> Array[AmberData]:
	var sacrifice_ambers: Array[AmberData]
	
	for sacrifice_amber in sacrifice.ambers:
		var bank_amber = type_to_amber[sacrifice_amber.type]
		bank_amber.next_value = bank_amber.value + sacrifice_amber.value
		sacrifice_ambers.append(bank_amber)
	
	return sacrifice_ambers

func reset_sacrifice() -> void:
	sacrifice = null
