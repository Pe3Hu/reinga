class_name Law
extends PanelContainer


var data: LawData:
	set(value_):
		data = value_
		connect_data()


func connect_data() -> void:
	visible = true
	update_labels()
	update_icons()

func update_icons() -> void:
	if data.modifier == 0: return
	var type_str = Catalog.modifier_to_string[data.modifier]
	var path_str = "res://entities/sanctuary/modifier/images/"
	var format_str = ".png"
	
	match data.decree.overlord.type:
		Bozo.Overlord.VIRELLO:
			path_str = "res://entities/ui/token/%s/" % type_str
			format_str = " on%s" % format_str
		Bozo.Overlord.KHARZEN:
			path_str = "res://entities/ui/token/faction/images/"
		Bozo.Overlord.SIREXIL:
			path_str = "res://entities/ui/token/faction/images/"
	
	%ModifierIcon.texture = load("%s%s%s" % [path_str, type_str, format_str])
	%ModifierIcon.material.set_shader_parameter("mask_texture", load("%s%s%s" % [path_str, type_str, format_str]))
	Helper.update_colors(%ModifierIcon, data.decree.overlord.type)
	
	type_str = Catalog.blob_to_string[data.blob]
	path_str = "res://entities/herald/decree/law/images/law "
	format_str = ".png"
	%BlobIcon.texture = load("%s%s%s" % [path_str, type_str, format_str])
	%BlobIcon.material.set_shader_parameter("mask_texture", load("%s%s%s" % [path_str, type_str, format_str]))
	Helper.update_colors(%BlobIcon, data.decree.overlord.type)


func update_labels() -> void:
	%OldLabel.text = data.old_text
	%NewLabel.text = data.new_text
