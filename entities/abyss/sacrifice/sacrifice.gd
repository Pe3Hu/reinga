class_name Sacrifice
extends Control


var data: SacrificeData:
	set(value_):
		data = value_
		#connect_datas()
		connect_signals()

var abyss: Abyss
var catena: Catena

@export var ambers: Array[TokenAmber]


func connect_datas() -> void:
	for _i in data.ambers.size():
		var amber = ambers[_i]
		var amber_data = data.ambers[_i]
		amber.data = amber_data

func connect_signals() -> void:
	if !data.is_selected_changed.is_connected(_on_is_selected_changed):
		data.is_selected_changed.connect(_on_is_selected_changed)
		data.is_updated.connect(_on_is_updated)
		#data.z_index_changed.connect(_on_z_index_changed)

		reset_margin()

func reset_margin() -> void:
	if data.catena.coord.y == 0:
		position.x = Catalog.CAGE_SIZE.x * (data.catena.coord.x - 1)
		%Background.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.JAIL_SIZE.y)
		
		var anchors = Catalog.windrose_to_anchor[Bozo.Windrose.S]
		%AmberPanel.size_flags_horizontal = anchors.front()
		%AmberPanel.size_flags_vertical = anchors.back()
	else:
		position.y = Catalog.CAGE_SIZE.y * (data.catena.coord.y - 1)
		%Background.size = Vector2(Catalog.JAIL_SIZE.x, Catalog.CAGE_SIZE.y)
		
		var anchors = Catalog.windrose_to_anchor[Bozo.Windrose.W]
		%AmberPanel.size_flags_horizontal = anchors.front()
		%AmberPanel.size_flags_vertical = anchors.back()
		%AmberGrid.columns = 1

func _on_is_selected_changed() -> void:
	if data.is_selected:
		abyss.hide_all_sacrifices()
		%AmberPanel.visible = data.is_selected
	
	abyss.sacrifice_button.visible = data.is_selected

func show_me() -> void:
	visible = true

func _on_is_updated() -> void:
	connect_datas()

func hide_ambers() -> void:
	%AmberPanel.visible = false

func show_ambers() -> void:
	%AmberPanel.visible = true
