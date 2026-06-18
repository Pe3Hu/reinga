extends TextureButton


@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)


@export var hell: Hell

var released_flag: bool = false
var status: Bozo.Status = Bozo.Status.OFF


#region init
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
#endregion

func _button_pressed() -> void:
	if released_flag:
		released_flag = false
		return
	
	switch_status()

func switch_status() -> void:
	status = Catalog.status_to_next[status]
	
	match status:
		Bozo.Status.ON:
			show_sanctuary()
		Bozo.Status.OFF:
			hide_sanctuary()

func show_sanctuary() -> void:
	hell.world.sanctuary.on_screen()
	texture_normal = load("res://entities/ui/button/variants/images/eye on.png")
	#texture_hover = load("res://entities/ui/button/images/eye off.png")

func hide_sanctuary() -> void:
	hell.world.sanctuary.off_screen()
	texture_normal = load("res://entities/ui/button/variants/images/eye off.png")
	#texture_hover = load("res://entities/ui/button/images/eye on.png")


func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed): return
	
	if Bozo.Status.ON:
		hide_sanctuary()
		released_flag = true
		await get_tree().process_frame
		released_flag = false
