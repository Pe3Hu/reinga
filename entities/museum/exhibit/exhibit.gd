class_name Exhibit
extends Control


var data: ExhibitData:
	set(value_):
		data = value_
		connect_datas()
		connect_signals()

var museum: Museum

var cage: Cage
@export var omen: TokenOmen
@export var desire: TokenDesire
@export var torture_frame: Frame


func connect_datas() -> void:
	omen.data = data.omen
	desire.data = data.desire
	desire.refill_progress()
	
	var trial_type = Catalog.desire_to_trial[desire.data.type]
	var overlord_type = Catalog.trial_to_overlord[trial_type]
	Helper.update_colors(%Domain, overlord_type)

func connect_signals() -> void:
	if !data.is_selected_changed.is_connected(_on_is_selected_changed):
		data.is_selected_changed.connect(_on_is_selected_changed)
		data.is_updated.connect(_on_is_updated)
		#data.z_index_changed.connect(_on_z_index_changed)

		reset_margin()

func reset_margin() -> void:
	position.x = (Catalog.CAGE_SIZE.x + Catalog.CAGE_OFFSET.x) * (Catalog.JAIL_CAGE_GRID.x - data.cage.coord.x - 1) 
	%Background.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.CAGE_SIZE.y)
	
	var anchors = Catalog.windrose_to_anchor[data.windrose]
	%Panel.size_flags_horizontal = anchors.front()
	%Panel.size_flags_vertical = anchors.back()

func _on_is_selected_changed() -> void:
	%Domain.visible = data.is_selected
	
	if data.is_selected:
		museum.hide_all_exhibits()
		visible = data.is_selected
		cage.sinner.visible = data.is_selected
	
	museum.realize_button.update_visible()

func _on_is_updated() -> void:
	connect_datas()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_check_mouse_position()

	if not (event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed): return
	
	if not torture_frame.visible: return
	_on_pressed()
	get_viewport().set_input_as_handled()

func _check_mouse_position() -> void:
	var local_mouse_pos = %Panel.get_local_mouse_position()
	var is_inside = Rect2(Vector2.ZERO, %Panel.size).has_point(local_mouse_pos)
	if is_inside == torture_frame.visible: return
	
	if is_inside and !torture_frame.visible:
		torture_frame.visible = true
	elif !is_inside and torture_frame.visible:
		torture_frame.visible = false

func _on_pressed() -> void:
	torture_frame.visible = false
	TooltipManager.clear()
	museum.data._on_exhibit_selected(data)
