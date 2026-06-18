extends CustomButton



@export var menu: MainMenu


func _button_pressed() -> void:
	menu.off_screen()
