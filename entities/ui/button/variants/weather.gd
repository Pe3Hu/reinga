extends TextureButton


@export var hover_scale: Vector2 = Vector2(1.1, 1.1)
@export var pressed_scale: Vector2 = Vector2(0.9, 0.9)

@export var hell: Hell
@export var gate: Gate
@export var abyss: Abyss

var released_flag: bool = false


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
	
	switch_weather()

func switch_weather() -> void:
	if !is_main_button(): return
	Scope.switch_weather()
	updaet_margin_offset()
	apply_weather()

func apply_weather() -> void:
	match Scope.layer:
		Bozo.Layer.HELL:
			if hell:
				hell.jail.apply_weather()
		Bozo.Layer.GATE:
			if gate:
				gate.apply_weather()
		Bozo.Layer.ABYSS:
			if abyss:
				abyss.apply_weather()

func updaet_margin_offset() -> void:
	match Scope.weather:
		Bozo.Weather.SUN:
			set_as_sun()
		Bozo.Weather.MOON:
			set_as_moon()

func set_as_sun() -> void:
	var parent = get_parent()
	parent.add_theme_constant_override("margin_left", -64)
	parent.add_theme_constant_override("margin_top", -64)
	texture_normal = load("res://entities/ui/button/images/weather sun.png")

func set_as_moon() -> void:
	var parent = get_parent()
	parent.add_theme_constant_override("margin_left", -78)
	parent.add_theme_constant_override("margin_top", -78)
	texture_normal = load("res://entities/ui/button/images/weather moon.png")


func _input(event: InputEvent) -> void:
	if !is_main_button(): return
	if not (event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and !event.pressed): return

	if Scope.weather == Bozo.Weather.MOON:
		switch_weather()
		released_flag = true
		await get_tree().process_frame
		released_flag = false

func is_main_button() -> bool:
	match Scope.layer:
		Bozo.Layer.HELL:
			return hell != null
		Bozo.Layer.GATE:
			return gate != null
		Bozo.Layer.ABYSS:
			return abyss != null
	return false
