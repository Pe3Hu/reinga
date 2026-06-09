extends CanvasLayer


const TOOLTIP_SCENE = preload("res://entities/ui/tooltip/tooltip.tscn")

var root_tooltip: Tooltip

var interacts: Array[TooltipInteract]
var focused_interact: TooltipInteract


func _input(event):
	if event.is_action_pressed("right_click"):
		on_right_click(event.position)

func on_right_click(mouse_pos: Vector2):
	clear()
	var data = get_tooltip_data()
	if data == null: return
	var source_rect = Rect2(mouse_pos, Vector2.ZERO)
	show_root(data, source_rect)


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
	
	if data.text.contains("%s "):
		data.text = data.text.replace("%s ", "")
	
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
	return target.data.tooltip

func get_tooltip_data() -> TooltipData:
	if interacts.is_empty(): return null
	focused_interact = interacts.back()
	var target_type = get_target_tooltip_type(focused_interact.target)
	var data = TooltipData.new()
	data.type = target_type#Catalog.type_to_tooltip[target_type]
	data.text = TooltipManager.get_template(data.type)
	
	match data.type:
		Bozo.Tooltip.SIN:
			data.text = data.text % Catalog.sin_to_string[focused_interact.target.data.type].capitalize()
			
			if focused_interact.target.get_parent().get_parent() is Claim:
				data.text = data.text.replace("Produces", "Consumes")
		Bozo.Tooltip.AMBER:
			data.text = data.text % Catalog.amber_to_string[focused_interact.target.data.type].capitalize()
			
		#Bozo.Tooltip.MADNESS:
			#data.text = data.text % Catalog.posture_to_string[target.type]
		#Bozo.Tooltip.OBLIVION:
		#	data.text = data.text % Catalog.posture_to_string[focused_interact.target.data.type]
	
	data.text = Catalog.tooltip_to_string[data.type].capitalize() + "\n" + data.text
	return data

func get_template(type_: Bozo.Tooltip) -> String:
	return Catalog.tooltip_to_template.get(type_ , "Unknown tooltip type")#, "Unknown tooltip type: %s" % type)
