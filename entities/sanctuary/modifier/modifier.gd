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
	data.value_changed.connect(_on_subvalue_changed)
	_on_type_changed()
	_on_value_changed()
	_on_subvalue_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	var type_str = Catalog.modifier_to_string[data.type]
	var path_str = "res://entities/sanctuary/modifier/images/"
	var format_str = ".png"
	
	match data.overlord:
		Bozo.Overlord.VIRELLO:
			path_str = "res://entities/ui/token/%s/" % type_str
			format_str = " on%s" % format_str
		Bozo.Overlord.KHARZEN:
			path_str = "res://entities/ui/token/faction/images/"
		Bozo.Overlord.SIREXIL:
			path_str = "res://entities/ui/token/faction/images/"
	
	#print("%s%s%s" % [path_str, type_str, format_str])
	icon.texture = load("%s%s%s" % [path_str, type_str, format_str])
	icon.material.set_shader_parameter("mask_texture", load("%s%s%s" % [path_str, type_str, format_str]))
	Helper.update_colors(icon, data.overlord)

func _on_value_changed() -> void:
	match data.overlord:
		Bozo.Overlord.XALVORR:
			label.text = str(data.value) + "%"
		Bozo.Overlord.VIRELLO:
			label.text = str(data.value) + " - "
		Bozo.Overlord.KHARZEN:
			label.text = str(data.value)
		Bozo.Overlord.CALTHEX:
			label.text = str(data.value)
		Bozo.Overlord.SIREXIL:
			label.text = str(data.value)
		Bozo.Overlord.MARVONE:
			label.text = str(data.value) + "%"

func _on_subvalue_changed() -> void:
	match data.overlord:
		Bozo.Overlord.VIRELLO:
			label.text = label.text + str(data.subvalue)
