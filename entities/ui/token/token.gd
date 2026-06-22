class_name Token
extends Panel


var data: Resource:
	set(value_):
		disconnect_signals()
		data = value_
		if data != null:
			connect_signals()
		else:
			_clear_binding()


@export var texture_rect: TextureRect
@export var label: Label


func disconnect_signals() -> void:
	if data == null: return
	
	if data.value_changed.is_connected(_on_value_changed):
		data.value_changed.disconnect(_on_value_changed)

func connect_signals() -> void:
	if data == null: return
	
	if data.value_changed.is_connected(_on_value_changed):
		data.value_changed.disconnect(_on_value_changed)
	
	data.value_changed.connect(_on_value_changed)
	_on_value_changed()


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			click_event()

func click_event() -> void:
	pass

func _on_value_changed():
	if data == null: return
	
	label.text = str(data.value)
	visible = data.value != 0
	
	if data.always_visible:
		visible = true

func _clear_binding() -> void:
	visible = false
	
	if label:
		label.text = ""

func reset() -> void:
	disconnect_signals()
	data = null
