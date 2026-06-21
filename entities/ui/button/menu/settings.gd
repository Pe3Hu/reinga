extends CustomButton


@export var menu: MainMenu


func _button_pressed() -> void:
	menu.menu_panel.visible = false
	menu.setting_tabs.visible = true
