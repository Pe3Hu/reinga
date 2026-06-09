class_name Spectacle
extends PanelContainer


var data: SpectacleData:
	set(value_):
		data = value_
		apply_data_info()


@export var icon: TextureRect


func apply_data_info() -> void:
	if !data.is_selected_changed.is_connected(_on_is_selected_changed):
		data.is_selected_changed.connect(_on_is_selected_changed)
	
	_on_type_changed()
	_on_is_selected_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	icon.texture = load("res://entities/hell/platform/spectacle/images/%s.png" % Catalog.spectacle_to_string[data.type])
	if data.catena.coord == Vector2i(1, 1):
		icon.flip_h = true

func _on_is_selected_changed() -> void:
	icon.visible = data.is_selected
