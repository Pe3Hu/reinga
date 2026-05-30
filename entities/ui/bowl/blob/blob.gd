@tool
class_name Blob
extends TextureRect


var data: BlobData:
	set(value_):
		data = value_
		apply_data_info()

func apply_data_info() -> void:
	data.bowl.type_changed.connect(_on_visual_changed)
	data.bowl.attitude.trial.type_changed.connect(_on_visual_changed)
	data.is_active_changed.connect(_on_visual_changed)
	_on_visual_changed()

func _on_visual_changed() -> void:
	if data.bowl.type == 0: return
	texture = load("res://entities/ui/bowl/blob/images/%s.png" % Catalog.blob_to_string[data.bowl.type])
	
	if data.is_active and data.bowl.attitude.trial.type != 0:
		modulate = Catalog.trial_to_color[data.bowl.attitude.trial.type]
		return
	
	modulate = Catalog.blob_default_color
