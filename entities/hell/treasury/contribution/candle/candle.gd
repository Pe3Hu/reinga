@tool
class_name Candle
extends Control


var data: CandleData:
	set(value_):
		data = value_
		apply_data_info()

@export var contribution: Contribution
@export var axis: ColorRect
@export var ball: ColorRect

#@export var active_border: ColorRect


#func _ready():
#	active_border.pivot_offset = active_border.size / 2.0
#	active_border.material = ShaderMaterial.new()

func apply_data_info() -> void:
	data.contribution.windrose_changed.connect(_on_windrose_changed)
	data.is_selected_changed.connect(_is_selected_changed)
	unique_shaders()
	_is_selected_changed()
	_on_windrose_changed()

func unique_shaders() -> void:
	axis.material = ShaderMaterial.new()
	axis.material.shader = load("uid://b4ancten2g7gc")
	ball.material = ShaderMaterial.new()
	ball.material.shader = load("uid://bospkr37o0a8i")
	var ball_seed = randf_range(0.1, 10.0)
	ball.material.set_shader_parameter("seed", ball_seed)

func _on_windrose_changed() -> void:
	var anchors = Catalog.windrose_to_anchor[data.contribution.type]
	ball.size_flags_horizontal = anchors.front()
	ball.size_flags_vertical = anchors.back()
	var axis_state = Catalog.windrose_to_state[data.contribution.type]
	axis.material.set_shader_parameter("state", axis_state)

func update_hue() -> void:
	var token = contribution.data.best_sins.pick_random()
	var color = Catalog.token_to_color[token.type]
	var hue_shift = color.h
	ball.material.set_shader_parameter("hue_shift", hue_shift)

func _is_selected_changed() -> void:
	contribution.active_border.visible = data.is_selected
	contribution.background.visible = !data.is_selected

func _on_color_rect_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			contribution.treasury.undo_resort()
