extends CanvasLayer

const TOOLTIP_SCENE = preload("res://entities/ui/tooltip/tooltip.tscn")

var root_tooltip: Tooltip


func show_root(data: TooltipData, source_rect: Rect2) -> Tooltip:
	_clear()

	var t := _create_tooltip(data, null)
	root_tooltip = t

	t.source_rect = source_rect

	_position_tooltip(t, source_rect.position)

	return t


func show_child(parent: Tooltip, data: TooltipData, pos: Vector2) -> Tooltip:
	if parent.child:
		parent.child.destroy_branch()

	var tooltip := _create_tooltip(data, parent)
	parent.child = tooltip
	var child_offset = Vector2(-8, -8)
	_position_tooltip(tooltip, pos + child_offset)

	return tooltip


func _create_tooltip(data: TooltipData, parent: Tooltip) -> Tooltip:
	var t: Tooltip = TOOLTIP_SCENE.instantiate()
	add_child(t)
	t.setup(data, parent)
	return t


func _position_tooltip(t: Tooltip, pos: Vector2):
	var offset_ = Vector2(24, 24)
	var final_pos = pos + offset_

	var viewport_rect = get_viewport().get_visible_rect()
	var size = t.size

	if final_pos.x + size.x > viewport_rect.size.x:
		final_pos.x -= size.x + 32

	if final_pos.y + size.y > viewport_rect.size.y:
		final_pos.y -= size.y + 32

	t.global_position = final_pos


func _clear():
	if root_tooltip:
		root_tooltip.destroy_branch()
		root_tooltip = null


func update_root_hover():
	if not root_tooltip:
		return

	var mouse := get_viewport().get_mouse_position()

	if root_tooltip._is_mouse_in_interest_area(mouse):
		return

	root_tooltip.destroy_branch()
	root_tooltip = null


func _process(_delta):
	update_root_hover()


func get_template(type_: Bozo.Tooltip) -> String:
	return Catalog.tooltip_to_template.get(type_ , "Unknown tooltip type")#, "Unknown tooltip type: %s" % type)
