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

func resort(token_: Token) -> void:
	if token_ is TokenSin:
		resort_sin(token_.type)
	if token_ is TokenPosture:
		resort_posture(token_.type)
	if token_ is TokenJudgment:
		resort_judgment(token_.type)
	
	reorder_tribute()
	hell.jail.reset_active_cage()

func resort_sin(type_: Bozo.Sin) -> void:
	tributes.sort_custom(func(a, b):
		return a.get_token(type_).value > b.get_token(type_).value
	)

func resort_posture(type_: Bozo.Posture) -> void:
	if type_ == Bozo.Posture.MADNESS: return
	tributes.sort_custom(func(a, b):
		return a.get_token(type_).value > b.get_token(type_).value
	)

func resort_judgment(type_: Bozo.Judgment) -> void:
	tributes.sort_custom(func(a, b):
		return a.get_token(type_).value > b.get_token(type_).value
	)

func reorder_tribute() -> void:
	for _i in range(tributes.size()):
		%Tributes.move_child(tributes[_i], _i)

func undo_resort() -> void:
	tributes.sort_custom(func(a, b):
		return Catalog.tribute_windroses.find(a.candle.windrose) < Catalog.tribute_windroses.find(b.candle.windrose)
	)
	reorder_tribute()
	hell.jail.reset_active_cage()
