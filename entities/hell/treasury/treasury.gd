class_name Treasury
extends PanelContainer


@export var tribute_scene: PackedScene

@export var hell: Hell

var tributes: Array[Tribute]


func _ready() -> void:
	init_tributes()

func init_tributes() -> void:
	for windrose in Catalog.tribute_windroses:
		add_tribute(windrose)

func add_tribute(windrose_: Bozo.Windrose) -> void:
	var tribute = tribute_scene.instantiate()
	var index = Catalog.windroses.find(windrose_)
	var cage = hell.jail.cages.get_child(index)
	%Tributes.add_child(tribute)
	tributes.append(tribute)
	tribute.treasury = self
	tribute.candle.windrose = windrose_
	tribute.cage = cage
	cage.tribute = tribute

func get_tribute(windrose_: Bozo.Windrose) -> Tribute:
	var index = Catalog.tribute_windroses.find(windrose_)
	return tributes[index]

func update_tributes() -> void:
	for tribute in tributes:
		tribute.update_tokens()
