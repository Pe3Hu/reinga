class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		
		update_tokens()

@export var cloak: Cloak
@export var primary_tokens: Array[TokenDesire]
@export var secondary_token: TokenDesire
@export var desires: Array[TokenDesire]

var dissolves: Array[TokenDesire]


func update_tokens() -> void:
	if !data: return
	for token in primary_tokens:
		token.type = data.primary_desire
	
	secondary_token.type = data.secondary_desire

func start_dissolve_tokens() -> void:
	cloak.cage.jail.hell.nightmare.dissolve_dreams.append(self)
	dissolves.append_array(desires)
	
	for token in desires:
		token.dissolve()

func end_dissolve(desire_: TokenDesire) -> void:
	dissolves.erase(desire_)
	
	if dissolves.is_empty():
		cloak.cage.jail.hell.nightmare.end_dream_dissolve(self)
		cloak.cage.switch_side()
