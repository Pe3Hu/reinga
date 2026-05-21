@tool
class_name TokenRank
extends Token


@export var type: Bozo.Rank:
	set(value_):
		type = value_
		#if type == 0: return
		#texture_rect.texture = load("res://entities/token/rank/rank.gd")
		#texture_rect.modulate = Color.WHITE

@export var value: int: 
	set(value_):
		value = value_
		label.text = str(value)
		#visible = value > 0


func reset() -> void:
	value = 0
