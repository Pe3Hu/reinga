class_name Gallery
extends PanelContainer


var data: GalleryData:
	set(value_):
		data = value_
		
		connect_datas()
		reset()

@export var cage_scene: PackedScene
@export var exhibit_scene: PackedScene

@export var museum: Museum
@export var realize_button: CustomButton
@export var weather_button: TextureButton

@export var cages: Array[Cage]
var exhibits: Array[Exhibit]


#region init
func connect_datas() -> void:
	connect_cages()
	connect_sinners()
	connect_exhibits()

func connect_cages() -> void:
	if cages.is_empty():
		for cage_data in data.museum.table.cages:
			add_cage(cage_data)
	else:
		for _i in data.museum.table.cages.size():
			var cage_data = data.museum.table.cages[_i]
			var cage = cages[_i]
			cage.data = cage_data
			cage.active_background.material = ShaderMaterial.new()
			cage.active_background.material.shader = load("uid://f0xra3senpov")

func reset() -> void:
	#await get_tree().process_frame
	Scope.weather = Bozo.Weather.SUN
	weather_button.updaet_margin_offset()
	data.reset_exhibits()
	show_all_exhibits()

func add_cage(data_: CageData) -> void:
	var cage = cage_scene.instantiate()
	cage.data = data_
	cage.gallery = self
	%Cages.add_child(cage)
	cages.append(cage)
	cage.active_background.material = ShaderMaterial.new()
	cage.active_background.material.shader = load("uid://f0xra3senpov")

func connect_exhibits() -> void:
	if exhibits.is_empty():
		for exhibit_data in data.exhibits:
			add_exhibit(exhibit_data)
	else:
		for _i in data.exhibits.size():
			var exhibit_data = data.exhibits[_i]
			var exhibit = exhibits[_i]
			exhibit.data = exhibit_data

func add_exhibit(data_: ExhibitData) -> void:
	var exhibit = exhibit_scene.instantiate()
	%Exhibits.add_child(exhibit)
	exhibit.data = data_
	exhibit.gallery = self
	var cage_index = int(exhibits.size() * 0.5)
	exhibits.append(exhibit)
	exhibit.cage = cages[cage_index]

func connect_sinners() -> void:
	for _i in data.sinners.size():
		var sinner_data = data.sinners[_i]
		var cage = cages[_i]
		cage.data.sinner = sinner_data
		cage.sinner.data = sinner_data
		cage.cloak.dream.data = sinner_data.dream
		
		cage.sinner.visible = true
		cage.passive_background.z_index = 1
	
	#if %Exhibits.get_child_count() == 0:
		#init_exhibits()
	#else:
		#for _i in data.exhibits.size():
			#var exhibit = exhibits[_i]
			#var exhibit_data = data.exhibits[_i]
			#exhibit.data = exhibit_data
#endregion


func _input(event: InputEvent) -> void:
	if Scope.layer != Bozo.Layer.MUSEUM: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not %Panel.get_global_rect().has_point(get_global_mouse_position()):
				if !realize_button.is_mouse_inside():
					data.reset_exhibits()
					show_all_exhibits()

func apply_weather() -> void:
	for cage in cages:
		cage.apply_weather()

func hide_all_exhibits() -> void:
	for exhibit in exhibits:
		exhibit.visible = false
	
	for cage in cages:
		cage.sinner.visible = false
		cage.show_background(false)

func show_all_exhibits() -> void:
	for exhibit in exhibits:
		exhibit.visible = true
	
	for cage in cages:
		cage.sinner.visible = true
		cage.show_background(false)
