@tool
class_name TokenFaction
extends Token


@export var type: Bozo.Faction:
	set(value_):
		type = value_
		if type == 0: return
		#texture_rect.texture = load("res://entities/token/images/faction.png")
		texture_rect.modulate = Catalog.faction_to_color[type]
