@tool
class_name Modifier
extends PanelContainer


var data: ModifierData:
	set(value_):
		data = value_
		apply_data_info()

@export var icon: TextureRect
@export var label: RichTextLabel


func apply_data_info() -> void:
	data.type_changed.connect(_on_type_changed)
	data.value_changed.connect(_on_value_changed)
	_on_type_changed()
	_on_value_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	icon.texture = load("res://entities/hell/underground/shelter/modifier/images/%s.png" % Catalog.modifier_to_string[data.type])

func _on_value_changed() -> void:
	label.text = str(data.value) + "%"
