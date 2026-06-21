class_name Ascension
extends Control


@export var world: World

@export var rebirth_button: CustomButton


func off_screen() -> void:
	visible = false
	world.switch_menu()

func on_screen():
	visible = true
