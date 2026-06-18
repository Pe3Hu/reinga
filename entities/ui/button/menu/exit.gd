extends CustomButton


@export var menu: MainMenu


func _button_pressed() -> void:
	get_tree().quit()
