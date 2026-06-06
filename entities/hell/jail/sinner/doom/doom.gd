class_name Doom
extends PanelContainer


var data: DoomData:
	set(value_):
		data = value_
		connect_datas()

@export var soul: Soul
@export var family: TokenOmen
@export var destiny: TokenOmen

@export var omens: Array[TokenOmen]

func connect_datas() -> void:
	family.reset()
	destiny.reset()
	
	if data.family:
		family.data = data.family
	if data.destiny:
		destiny.data = data.destiny
	
	rearrange_omens()

func rearrange_omens() -> void:
	var windroses: Array[Bozo.Windrose]
	
	if destiny.data:
		var options = Catalog.omen_to_windroses[destiny.data.subtype].duplicate()
		
		var windrose = options.pick_random()
		var anchors = Catalog.windrose_to_anchor[windrose]
		destiny.size_flags_horizontal = anchors.front()
		destiny.size_flags_vertical = anchors.back()
		windroses.append(windrose)
	
	if family.data:
		var options = Catalog.omen_to_windroses[family.data.subtype].duplicate()
		
		if !windroses.is_empty():
			options.erase(windroses.back())
		
		var windrose = options.pick_random()
		var anchors = Catalog.windrose_to_anchor[windrose]
		family.size_flags_horizontal = anchors.front()
		family.size_flags_vertical = anchors.back()
		windroses.append(windrose)

func apply_select_visiblity(is_cage_selected_: bool = false) -> void:
	for omen in omens:
		if omen.data:
			var flag = true
			
			if is_cage_selected_:
				flag = Catalog.status_to_bool[omen.data.status]
			
			omen.visible = flag
