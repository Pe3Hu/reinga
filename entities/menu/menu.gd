class_name MainMenu
extends Control


@export var start: CustomButton
@export var unpause: CustomButton
@export var settings: CustomButton
@export var exit: CustomButton



func off_screen() -> void:
	get_tree().paused = false
	visible = false

func on_screen():
	get_tree().paused = true
	visible = true
	start.visible = !Scope.is_game
	unpause.visible = Scope.is_game
