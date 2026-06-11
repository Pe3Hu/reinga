class_name TooltipInteract
extends Control

@export var target: Control

var tooltip: Tooltip


func _ready():
	mouse_entered.connect(_on_enter)
	mouse_exited.connect(_on_exit)

func _on_enter():
	TooltipManager.interacts.append(self)

func _on_exit():
	if TooltipManager.focused_interact == self:
		TooltipManager.focused_interact = null
	TooltipManager.interacts.erase(self)

func get_resolved_target() -> Control:
	if target:
		return target
	var parent_node := get_parent()
	if parent_node is Control:
		return parent_node as Control
	return null
