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
		#TooltipManager.clear()
		TooltipManager.focused_interact = null
	#TooltipManager.interacts.erase(self)
