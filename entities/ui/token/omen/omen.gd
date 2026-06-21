@tool
class_name TokenOmen
extends Token


func _on_value_changed() -> void:
	if data == null:
		return
	label.text = str(data.token.value)
	visible = data.token.value != 0
	
	if data.token.always_visible:
		visible = true

func disconnect_signals() -> void:
	if data == null:
		return
	if data.type_changed.is_connected(update_texture):
		data.type_changed.disconnect(update_texture)
	if data.subtype_changed.is_connected(update_texture):
		data.subtype_changed.disconnect(update_texture)
	if data.status_changed.is_connected(update_texture):
		data.status_changed.disconnect(update_texture)
	if data.token.value_changed.is_connected(_on_value_changed):
		data.token.value_changed.disconnect(_on_value_changed)

func connect_signals() -> void:
	disconnect_signals()
	if data == null:
		return
	if !data.type_changed.is_connected(update_texture):
		data.type_changed.connect(update_texture)
		data.subtype_changed.connect(update_texture)
		data.status_changed.connect(update_texture)
		data.token.value_changed.connect(_on_value_changed)
	
	visible = true
	_on_value_changed()
	update_texture()

func update_texture() -> void:
	if data == null or data.type == 0:
		return
	var path: String = "res://entities/ui/token/omen/images/"
	match data.type:
		Bozo.Omen.FAMILY:
			path += Catalog.family_to_string[data.subtype]
		Bozo.Omen.DESTINY:
			path += Catalog.destiny_to_string[data.subtype]
	
	path += " " + Catalog.status_to_string[data.status]+ ".png"
	texture_rect.texture = load(path)
	texture_rect.modulate = Catalog.sin_to_color[data.token.type]
	
	label.visible = Bozo.Status.ON == data.status

func _clear_binding() -> void:
	visible = false
	if texture_rect:
		texture_rect.texture = null
	if label:
		label.visible = false
		label.text = ""

func reset() -> void:
	disconnect_signals()
	data = null
