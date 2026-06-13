extends CustomButton


@export var hell: Hell


func _on_pressed() -> void:
	show_sanctuary()

func show_sanctuary() -> void:
	hell.world.sanctuary.on_screen()
	disabled = true

func hide_sanctuary() -> void:
	hell.world.sanctuary.off_screen()
	button_pressed = false
	disabled  = false

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed): return
	#var hovered := get_viewport().gui_get_hovered_control()
	#if hovered == null or (hovered != self and not is_ancestor_of(hovered)): return
	if disabled:
		hide_sanctuary()
	#get_viewport().set_input_as_handled()
