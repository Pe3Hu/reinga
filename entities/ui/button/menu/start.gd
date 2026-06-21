extends CustomButton


@export var menu: MainMenu


func _button_pressed() -> void:
	super._button_pressed()
	menu.world.new_game()
