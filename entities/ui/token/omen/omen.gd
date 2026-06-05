@tool
class_name TokenOmen
extends Token


func _on_value_changed() -> void:
	label.text = str(data.token.value)
	visible = data.token.value != 0
	
	if data.token.always_visible:
		visible = true

func apply_data_info() -> void:
	if !data.type_changed.is_connected(update_texture):
		data.type_changed.connect(update_texture)
		data.subtype_changed.connect(update_texture)
		data.status_changed.connect(update_texture)
		data.token.value_changed.connect(_on_value_changed)
	
	_on_value_changed()
	update_texture()

func update_texture() -> void:
	if data.type == 0: return
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
