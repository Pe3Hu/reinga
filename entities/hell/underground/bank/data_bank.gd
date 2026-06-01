class_name BankData
extends Resource



var hell: HellData
var ambers: Array[AmberData]
var postures: Array[PostureData]

var type_to_amber: Dictionary
var type_to_posture: Dictionary


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

func init_postures() -> void:
	for type in Catalog.postures:
		add_posture(type)

func add_posture(type_: Bozo.Posture) -> void:
	var default_value = 20
	var posture = PostureData.new(type_, default_value)
	postures.append(posture)
	type_to_posture[type_] = posture

#func test_change() -> void:
	#var amber = ambers[1]
	#amber.value += 1
