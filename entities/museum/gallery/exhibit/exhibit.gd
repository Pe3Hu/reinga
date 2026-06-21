class_name Exhibit
extends Control


var data: ExhibitData:
	set(value_):
		data = value_
		
		connect_datas()
		connect_signals()

var gallery: Gallery

var cage: Cage:
	set(value_):
		cage = value_
		cage.active_background.z_index = 1
@export var omen: TokenOmen
@export var desire: TokenDesire
@export var torture_frame: Frame


func connect_datas() -> void:
	if data == null:
		return
	omen.data = data.omen
	desire.data = data.desire
	desire.refill_progress()
	Helper.update_colors(%Domain, get_overloard())
	bind_cage_from_data()

func bind_cage_from_data() -> void:
	if gallery == null or data == null:
		return
	var cage_node = gallery.find_cage_node(data.cage)
	if cage_node:
		cage = cage_node

func get_overloard() -> Bozo.Overlord:
	var trial_type = Catalog.desire_to_trial[desire.data.type]
	var overlord_type = Catalog.trial_to_overlord[trial_type]
	return overlord_type

func connect_signals() -> void:
	if data == null:
		return
	if !data.is_selected_changed.is_connected(_on_is_selected_changed):
		data.is_selected_changed.connect(_on_is_selected_changed)
		data.is_updated.connect(_on_is_updated)
	
	reset_margin()

func reset_margin() -> void:
	if data == null:
		return
	
	var slot_index = gallery.get_cage_slot_index(data.cage) if gallery else data.cage.coord.x
	position.x = (Catalog.CAGE_SIZE.x + Catalog.CAGE_OFFSET.x) * slot_index
	%Background.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.CAGE_SIZE.y)
	
	var anchors = Catalog.windrose_to_anchor[data.windrose]
	%Panel.size_flags_horizontal = anchors.front()
	%Panel.size_flags_vertical = anchors.back()

func _on_is_selected_changed() -> void:
	%Domain.visible = data.is_selected
	
	if data.is_selected:
		gallery.hide_all_exhibits()
		visible = true
		cage.sinner.visible = true
		cage.show_background(true)
		Helper.update_colors(cage.active_background, get_overloard())
	elif gallery.data.active_exhibits.is_empty():
		gallery.show_all_exhibits()
	
	gallery.forge_button.update_visible()

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
	gallery.data._on_exhibit_selected(data)
