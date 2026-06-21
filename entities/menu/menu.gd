class_name MainMenu
extends Control


@export var world: World

@export var start: CustomButton
@export var unpause: CustomButton
@export var settings: CustomButton
@export var exit: CustomButton

@export var setting_tabs: TabContainer
@export var menu_panel: MarginContainer


func off_screen() -> void:
	get_tree().paused = false
	visible = false

func on_screen():
	get_tree().paused = true
	visible = true
	start.visible = !Scope.is_game
	unpause.visible = Scope.is_game
