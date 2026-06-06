class_name Doom
extends PanelContainer


var data: DoomData:
	set(value_):
		data = value_
		connect_datas()

@export var soul: Soul
@export var family: TokenOmen
@export var destiny: TokenOmen


func connect_datas() -> void:
	family.reset()
	destiny.reset()
	
	if data.family:
		family.data = data.family
	if data.destiny:
		destiny.data = data.destiny
	
	rearrange_omens()

func rearrange_omens() -> void:
	var anchors = Catalog.windrose_to_anchor[data.contribution.type]
	family.size_flags_horizontal = anchors.front()
	family.size_flags_vertical = anchors.back()
	
	anchors = Catalog.windrose_to_anchor[data.contribution.type]
	destiny.size_flags_horizontal = anchors.front()
	destiny.size_flags_vertical = anchors.back()
