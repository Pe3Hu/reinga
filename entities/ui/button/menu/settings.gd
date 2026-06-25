extends CustomButton


@export var menu: MainMenu


func _button_pressed() -> void:
	menu.show_settings()
