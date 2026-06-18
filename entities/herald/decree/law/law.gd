class_name Law
extends PanelContainer


var data: LawData:
	set(value_):
		data = value_
		connect_data()


func connect_data() -> void:
	visible = true
	
	%Modifier.visible = data.fate == Bozo.Fate.NONE
	%Fate.visible = data.fate != Bozo.Fate.NONE
	
	update_labels()
	update_icons()

func update_icons() -> void:
	if data.modifier == 0: return
	%Smoke.visible = data.decree.overlord.type == Bozo.Overlord.SIREXIL 
	
	var type_str: String = Catalog.modifier_to_string[data.modifier]
	var path_str: String
	var format_str: String = ".png"
	
	if data.fate == Bozo.Fate.NONE:
		path_str = "res://entities/sanctuary/modifier/images/"
		
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
	else:
		path_str = "res://entities/ui/token/faction/images/"
		
		%FactionIcon.texture = load("%s%s%s" % [path_str, type_str, format_str])
		%FactionIcon.material.set_shader_parameter("mask_texture", load("%s%s%s" % [path_str, type_str, format_str]))
		Helper.update_colors(%FactionIcon, data.decree.overlord.type)
		Helper.update_colors(%PlusIcon, data.decree.overlord.type)
		
		var relationship = Catalog.fate_to_relationship[data.fate]
		var smoke_color: Color = Catalog.smoke_to_color[relationship]
		%Smoke.material.set_shader_parameter("fire_color", smoke_color)

func update_labels() -> void:
	if data.fate == Bozo.Fate.NONE:
		%OldLabel.text = data.old_text
		%NewLabel.text = data.new_text
	else:
		%FateLabel.text = data.fate_text
