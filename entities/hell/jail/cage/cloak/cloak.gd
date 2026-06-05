@tool
class_name Cloak
extends Control


@export var cage: Cage
@export var dream: Dream

var type: Bozo.Tooltip = Bozo.Tooltip.CLOAK



func hide_dream() -> void:
	dream.visible = false

func show_dream() -> void:
	dream.visible = true
