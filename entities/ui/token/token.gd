class_name Token
extends Panel


var data: Resource:
	set(value_):
		data = value_
		apply_data_info()

@export var contribution: Contribution

@export var texture_rect: TextureRect
@export var label: Label




func apply_data_info() -> void:
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			click_event()

func click_event() -> void:
	if contribution != null:
		contribution.treasury.reoder(data.type)
		contribution.treasury.sort_icon_shift(self)

func _on_value_changed():
	label.text = str(data.value)
	visible = data.value != 0
	
	if data.always_visible:
		visible = true
