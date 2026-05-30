class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		apply_data_info()

@export var cloak: Cloak
@export var primary_tokens: Array[TokenDesire]
@export var secondary_token: TokenDesire
@export var desires: Array[TokenDesire]

var dissolves: Array[TokenDesire]


func apply_data_info() -> void:
	if !data: return
	if! data.primary_desire_changed.is_connected(_on_desires_changed):
		data.primary_desire_changed.connect(_on_desires_changed)
		data.secondary_desire_changed.connect(_on_desires_changed)
		_on_desires_changed()
		cloak.visible = true

func _on_desires_changed() -> void:
	for token in primary_tokens:
		token.data = data.primary
	
	secondary_token.data = data.secondary

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
