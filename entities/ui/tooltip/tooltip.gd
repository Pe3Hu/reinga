@tool
class_name Tooltip
extends PanelContainer


const PIN_DELAY := 0.6
const MOVE_THRESHOLD := 2.0
const FADE_TIME := 0.15
const META_DELAY := 0.1
const EDGE_PADDING := 8.0

@export var header_label: RichTextLabel
@export var descritipion_label: RichTextLabel
@export var close_button: TextureButton

var data: TooltipData
var parent: Tooltip
var child: Tooltip

var pinned := false
var hover_time := 0.0

var last_mouse_pos := Vector2.ZERO
var opacity_tween: Tween

var meta_timer: SceneTreeTimer
var pending_meta = null
var source_rect: Rect2


func _ready():
	%CloseTimer.wait_time = Gear.tooltips[Gear.tempo]
	header_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	header_label.mouse_default_cursor_shape = Control.CURSOR_ARROW
	descritipion_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	descritipion_label.mouse_default_cursor_shape = Control.CURSOR_ARROW

func setup(d: TooltipData, p: Tooltip):
	data = d
	parent = p
	%CloseTimer.start()

	header_label.text = _apply_template(data.header)
	descritipion_label.text = _apply_template(data.descritipion)

	update_size_to_fit_text()
	header_label.meta_hover_started.connect(_on_meta_hover)
	header_label.meta_hover_ended.connect(_on_meta_exit)
	descritipion_label.meta_hover_started.connect(_on_meta_hover)
	descritipion_label.meta_hover_ended.connect(_on_meta_exit)

	modulate.a = 0.0
	show()

	_fade(1.0)


func _apply_template(text: String) -> String:
	var regex := RegEx.new()
	regex.compile("\\[meta (.*?)\\](.*?)\\[/meta\\]")

	var matches = regex.search_all(text)
	var result := text

	for m in matches:
		var key = m.get_string(1)
		var label_text = m.get_string(2)

		var replacement = "[url=%s]%s[/url]" % [key, label_text]
		result = result.replace(m.get_string(0), replacement)

	return result

#region meta
func _on_meta_hover(meta):
	pending_meta = meta

	if meta_timer:
		meta_timer.timeout.disconnect(_spawn_pending_meta)

	meta_timer = get_tree().create_timer(META_DELAY)
	meta_timer.timeout.connect(_spawn_pending_meta)


func _spawn_pending_meta():
	if pending_meta == null: return
	var mouse := get_viewport().get_mouse_position()
	if not _is_mouse_in_interest_area(mouse): return
	var data_ := _get_meta_tooltip(pending_meta)
	child = TooltipManager.show_child(self, data_, mouse)
	%CloseTimer.stop()
	%CloseTimer.start()


func _on_meta_exit(_meta):
	pending_meta = null

	if child:
		child.destroy_branch()
		child = null

func _get_meta_tooltip(meta) -> TooltipData:
	var child_tooltip := TooltipData.new()
	child_tooltip.type = Catalog.string_to_tooltip[meta]
	#child_tooltip.header = meta
	var descritipion = TooltipManager.get_template(child_tooltip.type)
	var tooltip_type = Catalog.string_to_tooltip[meta]
	
	match tooltip_type:
		Bozo.Tooltip.SIN:
			descritipion = descritipion + "[ghost][meta essence]Essence[/meta][/ghost]"
		Bozo.Tooltip.AMBER:
			descritipion = descritipion.replace("[meta essence]%s[/meta]", "[ghost][meta essence]Essence[/meta][/ghost]")
		Bozo.Tooltip.SPECTACLE:
			if descritipion.contains(" %s,"):
				descritipion = descritipion.replace(" %s,", " [i]something[/i],")
		Bozo.Tooltip.TRIBUTE:
			descritipion = descritipion.replace("%s", "[ghost][meta overlord]Overlord[/meta][/ghost]")
		Bozo.Tooltip.ATTITUIDE:
			descritipion = descritipion.replace("%s", "[ghost][meta overlord]Overlord[/meta][/ghost]")
		Bozo.Tooltip.CLAIM:
			descritipion = descritipion.replace("%s", "[ghost][meta overlord]Overlord[/meta][/ghost]")
		Bozo.Tooltip.FLAME:
			descritipion = descritipion.replace("%s", "[ghost][meta overlord]Overlord[/meta][/ghost]")
		Bozo.Tooltip.TRIAL:
			descritipion = descritipion.replace("%s", "[ghost][meta overlord]Overlord[/meta][/ghost]")
	
	child_tooltip.descritipion = descritipion
	return child_tooltip
#endregion

#region lifecycle
func _process(delta):
	if pinned: return

	var mouse := get_viewport().get_mouse_position()
	var moved := mouse.distance_to(last_mouse_pos)

	if moved < MOVE_THRESHOLD:
		hover_time += delta
	else:
		hover_time = max(0.0, hover_time - delta * 2.0)

	if hover_time >= PIN_DELAY:
		pinned = true

	last_mouse_pos = mouse


func destroy_branch():
	if child:
		child.destroy_branch()

	_fade(0.0)
	TooltipManager.interacts.clear()

	await get_tree().create_timer(FADE_TIME).timeout
	queue_free()


func _fade(value: float):
	if opacity_tween:
		opacity_tween.kill()

	opacity_tween = create_tween()
	opacity_tween.tween_property(self, "modulate:a", value, FADE_TIME)
#endregion

func _is_mouse_in_interest_area(mouse: Vector2) -> bool:
	if source_rect.grow(EDGE_PADDING).has_point(mouse):
		return true

	var tooltip: Tooltip = self
	while tooltip:
		if tooltip.get_global_rect().grow(EDGE_PADDING).has_point(mouse): return true
		tooltip = tooltip.child

	tooltip = parent
	while tooltip:
		if tooltip.get_global_rect().grow(EDGE_PADDING).has_point(mouse): return true
		tooltip = tooltip.parent

	return false

func update_size_to_fit_text():
	# Получаем текущий шрифт и размер
	var font = get_theme_font("normal_font")
	var font_size = get_theme_font_size("normal_font_size")
	var visible_text = descritipion_label.get_parsed_text()

	# Calculate the size (returns a Vector2)
	var text_size = font.get_string_size(visible_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)
	var width = text_size.x + 16
	# Устанавливаем размер (добавляем небольшой отступ)
	size.x = width
	
	if data.type == Bozo.Tooltip.FAMILY or data.type == Bozo.Tooltip.DESTINY:
		size.y += text_size.y * 3 
		descritipion_label.custom_minimum_size.y += text_size.y * 3
	
	if data.type == Bozo.Tooltip.LEGEND or data.type == Bozo.Tooltip.COVENANT:
		size.x = 200
		size.y += text_size.y * 2 
		descritipion_label.custom_minimum_size.y += text_size.y * 2
	
	if data.type == Bozo.Tooltip.ARTISAN or data.type == Bozo.Tooltip.NOBILITY or data.type == Bozo.Tooltip.RIFFRAFF:
		size.x = 200
		size.y += text_size.y * 5 
		descritipion_label.custom_minimum_size.y += text_size.y * 5
	
	# Высоту можно получить через get_content_height()
	#size.y = label.get_content_height()


#region close
func close() -> void:
	close_button.visible = false
	TooltipManager.clear()
	%CloseTimer.stop()

func _on_button_pressed() -> void:
	close()

func _on_close_timer_timeout() -> void:
	close()
#endregion
