class_name CustomButton
extends BaseButton



@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)


func _ready() -> void:
	mouse_entered.connect(_button_enter)
	mouse_exited.connect(_button_exit)
	pressed.connect(_button_pressed)

	call_deferred("_init_pivot")


func _init_pivot() -> void:
	pivot_offset = size / 2.0


func _button_enter() -> void:
	create_tween().tween_property(self, "scale", hover_scale, 0.1)\
		.set_trans(Tween.TRANS_SINE)


func _button_exit() -> void:
	create_tween().tween_property(self, "scale", Vector2.ONE, 0.1)\
		.set_trans(Tween.TRANS_SINE)


func _button_pressed() -> void:
	var button_press_tween: Tween = create_tween()

	button_press_tween.tween_property(self, "scale", pressed_scale, 0.06)\
		.set_trans(Tween.TRANS_SINE)

	button_press_tween.tween_property(self, "scale", hover_scale, 0.12)\
		.set_trans(Tween.TRANS_SINE)

func hide_me() -> void:
	visible = false

func show_me() -> void:
	visible = true

func update_visible() -> void:
	pass

func activate() -> void:
	pass

func is_mouse_inside() -> bool:
	return get_global_rect().has_point(get_global_mouse_position())
