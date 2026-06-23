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
	posture.value = get_rank_posture_value(posture.type)
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

func activate_posture(posture_: PostureData) -> void:
	Scope.posture_to_factor[posture_.type] += 1
	Scope.equalize_posture_factors()
	type_to_posture[posture_.type].value += get_rank_posture_value(posture_.type)
	
	match posture_.type:
		Bozo.Posture.MADNESS:
			hell.jail.apply_madness()
		Bozo.Posture.OBLIVION:
			hell.world.abyss.counter += 1

func get_rank_posture_value(type_: Bozo.Posture) -> int:
	var value: int = 10
	
	if type_ == Bozo.Posture.OBLIVION:
		var overlord = hell.world.throne.marvone
		var rank = overlord.rank + Scope.posture_to_factor[type_]
		value = 2 * rank + 9
	
	return value
