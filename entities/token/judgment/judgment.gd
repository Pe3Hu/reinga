@tool
class_name TokenJudgment
extends Token


@export var type: Bozo.Judgment:
	set(value_):
		type = value_
		#if type == 0: return
		#texture_rect.texture = load("res://entities/token/judgment/judgment.gd")
		#texture_rect.modulate = Color.WHITE


func _ready() -> void:
	always_visible = true
