class_name Token
extends Panel


@export var contribution: Contribution

@export var texture_rect: TextureRect
@export var label: Label

@export var value: int: 
	set(value_):
		value = value_
		label.text = str(value)
		if !always_visible:
			visible = value != 0
		else:
			visible = true

var always_visible: bool = false


func reset() -> void:
	value = 0


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			click_event()

func click_event() -> void:
	if contribution != null:
		contribution.treasury.resort(self)
