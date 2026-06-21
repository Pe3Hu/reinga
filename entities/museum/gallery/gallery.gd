class_name Gallery
extends PanelContainer


var data: GalleryData:
	set(value_):
		data = value_
		
		if data == null or !data.is_prepared:
			return
		
		connect_datas()
		reset()

@export var cage_scene: PackedScene
@export var exhibit_scene: PackedScene

@export var museum: Museum
@export var forge_button: CustomButton
@export var weather_button: TextureButton

@export var cages: Array[Cage]
var exhibits: Array[Exhibit]


#region init
func connect_datas() -> void:
	if data == null or !data.is_prepared:
		return
	
	connect_cages()
	connect_sinners()
	connect_exhibits()
	
	simulate_forge()

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
	if data == null:
		return
	#await get_tree().process_frame
	Scope.weather = Bozo.Weather.SUN
	weather_button.apply_weather()
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
			exhibit.gallery = self
			exhibit.data = exhibit_data

func add_exhibit(data_: ExhibitData) -> void:
	var exhibit = exhibit_scene.instantiate()
	exhibit.gallery = self
	%Exhibits.add_child(exhibit)
	exhibit.data = data_
	exhibits.append(exhibit)

func find_cage_node(cage_data: CageData) -> Cage:
	for cage in cages:
		if cage.data == cage_data:
			return cage
	return null

func get_cage_slot_index(cage_data: CageData) -> int:
	for _i in cages.size():
		if cages[_i].data == cage_data:
			return _i
	
	return 0

func connect_sinners() -> void:
	for _i in cages.size():
		var cage = cages[_i]
		var sinner_data = data.sinners[_i] if _i < data.sinners.size() else null
		
		if cage.data:
			cage.data.sinner = sinner_data
		cage.sinner.data = sinner_data
		
		if sinner_data == null:
			cage.sinner.visible = false
			continue
		
		cage.sinner.visible = true
		cage.passive_background.z_index = 1
		cage.sinner.soul.show_all()
#endregion

func _input(event: InputEvent) -> void:
	if Scope.layer != Bozo.Layer.MUSEUM: return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not %Panel.get_global_rect().has_point(get_global_mouse_position()):
				if !forge_button.is_mouse_inside() and !weather_button.is_mouse_inside():
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
		cage.apply_weather()
		cage.show_background(false)

func stop_simulate_forge() -> void:
	%ForgeTimer.stop()

func simulate_forge() -> void:
	#if true: return
	#if !data.is_skip: return
	
	var duration = Gear.simulates[Gear.tempo] * 0.25
	%ForgeTimer.wait_time = duration
	%ForgeTimer.start()


func _on_forge_timer_timeout() -> void:
	if data == null or !data.is_prepared or data.exhibits.is_empty():
		%ForgeTimer.stop()
		return
	
	simulate_choice()
	forge_button._button_pressed()

func simulate_choice() -> void:
	if data == null or data.exhibits.is_empty(): return
	var exhibit = data.exhibits.back()
	data._on_exhibit_selected(exhibit)
