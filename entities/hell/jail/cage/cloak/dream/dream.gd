class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		
		update_tokens()

@export var primary_tokens: Array[TokenDesire]
@export var secondary_token: TokenDesire


func update_tokens() -> void:
	if !data: return
	for token in primary_tokens:
		token.type = data.primary_desire
	
	secondary_token.type = data.secondary_desire
