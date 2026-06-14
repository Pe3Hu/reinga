class_name Sacrifice
extends Control


var data: SacrificeData:
	set(value_):
		data = value_
		apply_data_info()

var abyss: Abyss
var catena: Catena


func apply_data_info() -> void:
	if !data.is_selected_changed.is_connected(_on_is_selected_changed):
		data.is_selected_changed.connect(_on_is_selected_changed)
		#data.z_index_changed.connect(_on_z_index_changed)

		reset_margin()

func reset_margin() -> void:
	if data.catena.coord.y == 0:
		position.x = Catalog.CAGE_SIZE.x * (data.catena.coord.x - 1)
		%Background.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.JAIL_SIZE.y)
		
		var anchors = Catalog.windrose_to_anchor[Bozo.Windrose.N]
		%Amber1.size_flags_horizontal = anchors.front()
		%Amber1.size_flags_vertical = anchors.back()
		
		anchors = Catalog.windrose_to_anchor[Bozo.Windrose.S]
		%Amber2.size_flags_horizontal = anchors.front()
		%Amber2.size_flags_vertical = anchors.back()
	else:
		position.y = Catalog.CAGE_SIZE.y * data.catena.coord.y  
		%Background.size = Vector2(Catalog.CAGE_SIZE.y, Catalog.JAIL_SIZE.x)
		%Background.rotation = PI * 3 / 2
		%Ambers.rotation = PI * 1 / 2
		
		#var anchors = Catalog.windrose_to_anchor[Bozo.Windrose.N]
		#%Amber1.size_flags_horizontal = anchors.front()
		#%Amber1.size_flags_vertical = anchors.back()
		#
		#anchors = Catalog.windrose_to_anchor[Bozo.Windrose.S]
		#%Amber2.size_flags_horizontal = anchors.front()
		#%Amber2.size_flags_vertical = anchors.back()

func _on_is_selected_changed() -> void:
	visible = data.is_selected
	abyss.select_button.visible = data.is_selected
	

func show_me() -> void:
	visible = true

func _on_z_index_changed() -> void:
	z_index = data.z_index
