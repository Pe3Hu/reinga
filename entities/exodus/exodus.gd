class_name Exodus
extends Control


@export var world: World

@export var rebirth_button: CustomButton


func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	update_texts()

func update_texts() -> void:
	%Body.text = "Earned Essence: %d" % Scope.essence
	%Header.text = "Congratulation with %s" % Catalog.exodus_to_string[Scope.exodus].capitalize()
