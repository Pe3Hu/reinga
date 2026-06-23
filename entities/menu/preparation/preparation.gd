class_name PreparationMenu
extends Control


@export var world: World


func off_screen() -> void:
	#visible = false
	get_tree().paused = false
	world.main_menu.off_screen()

func on_screen():
	#visible = true
	get_tree().paused = true
	world.main_menu.on_screen()
