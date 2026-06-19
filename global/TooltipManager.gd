extends CanvasLayer


const TOOLTIP_SCENE = preload("res://entities/ui/tooltip/tooltip.tscn")

var root_tooltip: Tooltip

var interacts: Array[TooltipInteract]
var focused_interact: TooltipInteract


func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("right_click"):
		on_right_click(event.global_position)

func on_right_click(mouse_pos: Vector2):
	clear()
	var hovered = pick_control_at(mouse_pos)
	var target = find_tooltip_target(hovered)
	if target == null: return
	var data = build_tooltip_data(target)
	if data == null: return
	var source_rect = Rect2(mouse_pos, Vector2.ZERO)
	show_root(data, source_rect)

func pick_control_at(global_pos: Vector2) -> Control:
	return _pick_deepest_control(get_tree().root, global_pos)

func _pick_deepest_control(node: Node, global_pos: Vector2) -> Control:
	if node is CanvasItem and not (node as CanvasItem).is_visible_in_tree(): return null
	
	for i in range(node.get_child_count() - 1, -1, -1):
		var child_pick := _pick_deepest_control(node.get_child(i), global_pos)
		if child_pick: return child_pick
	
	if node is Control:
		var control := node as Control
		if control.mouse_filter != Control.MOUSE_FILTER_IGNORE \
				and control.get_global_rect().has_point(global_pos):
			return control
	
	return null

func find_tooltip_target(hovered: Control) -> Control:
	if hovered == null: return null
	var cage_fallback: Control = null
	var current: Node = hovered
	while current:
		if current is Control:
			var control := current as Control
			if control is TooltipInteract:
				var interact_target = control.get_resolved_target()
				if interact_target and not _is_excluded_tooltip_target(interact_target):
					if interact_target is Cage:
						cage_fallback = interact_target
					elif _control_provides_tooltip(interact_target):
						return interact_target
			elif not _is_excluded_tooltip_target(control) and _control_provides_tooltip(control):
				if control is Cage:
					cage_fallback = control
				else:
					return control
		current = current.get_parent()
	return cage_fallback

func _is_excluded_tooltip_target(control: Control) -> bool:
	return control is Sinner \
		or control is Cloak #\
		#or control is Soul \
		#or control is Dream \
		#or control is Doom

func _control_provides_tooltip(control: Control) -> bool:
	if _is_excluded_tooltip_target(control): return false
	#if control is Platform or control is Spectacle:
	#	return control.data != null
	var data = control.get("data")
	if data != null and data.get("tooltip") != null: return true
	return false

func show_root(data: TooltipData, source_rect: Rect2) -> Tooltip:
	clear()
	var tooltip = create_tooltip(data, null)
	root_tooltip = tooltip
	tooltip.source_rect = source_rect
	update_tooltip_position(tooltip, source_rect.position)
	return tooltip

func show_child(parent: Tooltip, data: TooltipData, pos: Vector2) -> Tooltip:
	if parent.child:
		parent.child.destroy_branch()
	
	var tooltip := create_tooltip(data, parent)
	parent.child = tooltip
	tooltip.close_button.visible = false
	var child_offset = Vector2(-8, -8)
	update_tooltip_position(tooltip, pos + child_offset)
	return tooltip

func create_tooltip(data: TooltipData, parent: Tooltip) -> Tooltip:
	var tooltip: Tooltip = TOOLTIP_SCENE.instantiate()
	add_child(tooltip)
	tooltip.setup(data, parent)
	return tooltip

func update_tooltip_position(tooltip: Tooltip, pos: Vector2):
	var offset_ = Vector2(24, 24)
	var final_pos = pos + offset_
	
	var viewport_rect = get_viewport().get_visible_rect()
	var size = tooltip.size
	
	if final_pos.x + size.x > viewport_rect.size.x:
		final_pos.x -= size.x + 32
	
	if final_pos.y + size.y > viewport_rect.size.y:
		final_pos.y -= size.y + 32
	
	tooltip.global_position = final_pos

func clear():
	if root_tooltip:
		root_tooltip.destroy_branch()
		root_tooltip = null

func get_target_tooltip_type(target: Control) -> Bozo.Tooltip:
	#if target is Platform and target.data:
	#	return target.data.tooltip
	if target is Spectacle and target.data:
		return target.data.tooltip
	var data = target.get("data")
	if data != null and data.get("tooltip") != null:
		return data.tooltip
	return Bozo.Tooltip.NONE

func build_tooltip_data(target: Control) -> TooltipData:
	var target_type = get_target_tooltip_type(target)
	if target_type == Bozo.Tooltip.NONE: return null
	var data = TooltipData.new()
	data.type = target_type
	if !Catalog.tooltip_to_string.has(data.type): return null
	var descritipion = TooltipManager.get_template(data.type)
	
	match data.type:
		Bozo.Tooltip.SIN:
			var text_with_color = Helper.get_colored_sin(target.data.type)
			descritipion = descritipion % text_with_color
			
			#if target.get_parent().get_parent() is Claim:
			#	descritipion = descritipion.replace("Produces", "Consumes")
		Bozo.Tooltip.AMBER:
			var text_with_color = Helper.get_colored_amber(target.data.type)
			descritipion = descritipion % text_with_color
		Bozo.Tooltip.SPECTACLE:
			if target.data.type in Catalog.spectacle_to_string:
				var trigger_string = Catalog.spectacle_to_string[target.data.type]
				descritipion = descritipion.replace("[meta trigger]", "[meta %s]" % trigger_string)
			
				#var spectacle_string = Catalog.spectacle_to_string[target.data.type]
				#var spectacle_meta = "[ghost][meta %s]%s[/meta][/ghost]" % [spectacle_string, spectacle_string.capitalize()]
				#descritipion = descritipion % spectacle_meta #descritipion % Catalog.spectacle_to_string[target.data.type].capitalize()
		Bozo.Tooltip.OMEN:
			descritipion = TooltipManager.get_template(Bozo.Tooltip.OMEN)
			var trigger_string = Catalog.omen_to_string[target.data.subtype]
			descritipion = descritipion.replace("[meta trigger]", "[meta %s]" % trigger_string)
			var omen_string = Catalog.omen_to_string[target.data.type]
			var omen_meta = "[ghost][meta %s]%s[/meta][/ghost]" % [omen_string, omen_string.capitalize()]
			
			descritipion = descritipion % omen_meta
			#if target.data.type in Catalog.omen_to_string:
			#	var omen_descritipion = get_template(target.data.type)
			#	descritipion = omen_descritipion + descritipion# % Catalog.omen_to_string[target.data.type].capitalize()
		Bozo.Tooltip.TRAIT:
			var trigger_string = Catalog.trait_to_string[target.data.type]
			descritipion = descritipion.replace("[meta trigger]", "[meta %s]" % trigger_string)
			var side_type = Catalog.trait_to_cage[target.data.type]
			var side_string = Catalog.cage_to_string[side_type].capitalize()
			descritipion = descritipion % side_string
		Bozo.Tooltip.TRIBUTE:
			descritipion = apply_overlord(target.data.trial.overlord.type, descritipion)
		Bozo.Tooltip.ATTITUIDE:
			descritipion = apply_overlord(target.data.trial.overlord.type, descritipion)
		Bozo.Tooltip.CLAIM:
			descritipion = apply_overlord(target.data.trial.overlord.type, descritipion)
		Bozo.Tooltip.FLAME:
			descritipion = apply_overlord(target.data.trial.overlord.type, descritipion)
		Bozo.Tooltip.TRIAL:
			descritipion = apply_overlord(target.data.overlord.type, descritipion)
	
	data.descritipion = descritipion
	return data

func get_template(type_: Bozo.Tooltip) -> String:
	return Catalog.tooltip_to_template.get(type_ , "Unknown tooltip type")#, "Unknown tooltip type: %s" % type)

func apply_overlord(overlord_: Bozo.Overlord, descritipion_: String) -> String:
	var text_with_color = Helper.get_colored_overlord(overlord_)
	return descritipion_ % text_with_color
