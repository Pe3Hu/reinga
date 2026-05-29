class_name BankData
extends Resource



var hell: HellData
var ambers: Array[AmberData]
var type_to_ember: Dictionary


func _init(hell_: HellData) -> void:
	hell = hell_
	init_ambers()

func init_ambers() -> void:
	for type in Catalog.ambers:
		add_amber(type)

func add_amber(type_: Bozo.Amber) -> void:
	var amber = AmberData.new(type_)
	ambers.append(amber)
	type_to_ember[type_] = amber

func test_change() -> void:
	var amber = ambers[1]
	amber.value += 1
