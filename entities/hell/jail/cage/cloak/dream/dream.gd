class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		
		update_tokens()

@export var cloak: Cloak
@export var primary_tokens: Array[TokenDesire]
@export var secondary_token: TokenDesire


func update_tokens() -> void:
	if !data: return
	for token in primary_tokens:
		token.type = data.primary_desire
	
	secondary_token.type = data.secondary_desire

func dissolve_tokens() -> void:
	for token in primary_tokens:
		token.dissolve()
	
	secondary_token.dissolve()
	await get_tree().create_timer(Catalog.DESIRE_DISSOLVE_DURATION).timeout
	cloak.cage.switch_side()
