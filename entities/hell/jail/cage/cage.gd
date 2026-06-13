@tool
extends PanelContainer
class_name Cage


var data: CageData:
	set(value_):
		data = value_
		apply_data()

var jail: Jail
var gate: Gate
var contribution: Contribution

@export var active_background: ColorRect
@export var passive_background: ColorRect
@export var sinner: Sinner
@export var cloak: Cloak
@export var torture_frame: Frame


func apply_data() -> void:
	sinner.data = data.sinner

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_check_mouse_position()

	if not visible or not _can_select_cage(): return
	if not (event is InputEventMouseButton \
			and event.button_index == MOUSE_BUTTON_LEFT \
			and event.pressed): return
	
	var hovered := get_viewport().gui_get_hovered_control()
	if hovered == null or (hovered != self and not is_ancestor_of(hovered)): return
	_on_texture_button_pressed()
	get_viewport().set_input_as_handled()

func _can_select_cage() -> bool:
	match Scope.layer:
		Bozo.Layer.HELL:
			return jail != null and Scope.phase == Bozo.Phase.APPRAISEMENT
		Bozo.Layer.GATE:
			return gate != null
	
	return false

func _on_texture_button_pressed() -> void:
	if jail:
		jail.hell.eye_button.hide_sanctuary()
	torture_frame.visible = false
	TooltipManager.clear()
	
	match Scope.layer:
		Bozo.Layer.HELL:
			if jail and Scope.phase == Bozo.Phase.APPRAISEMENT:
				data.table._on_cage_jail_selected(data)
				jail.update_visiblity_omens()
		Bozo.Layer.GATE:
			if gate:
				gate.unblur_all()
				data.table._on_cage_gate_selected(data)


func _check_mouse_position() -> void:
	if active_background.visible: return
	var local_mouse_pos := get_local_mouse_position()
	var is_inside := Rect2(Vector2.ZERO, size).has_point(local_mouse_pos)
	if is_inside == torture_frame.visible: return
	
	if is_inside and !torture_frame.visible:
		torture_frame.visible = true
	elif !is_inside and torture_frame.visible:
		torture_frame.visible = false
