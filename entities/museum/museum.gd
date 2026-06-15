class_name Museum
extends Control


var data: MuseumData:
	set(value_):
		data = value_
		connect_datas()

@export var cage_scene: PackedScene
@export var exhibit_scene: PackedScene

@export var world: World
@export var realize_button: CustomButton
@export var weather_button: TextureButton

var cages: Array[Cage]
var exhibits: Array[Exhibit]


#region init
func connect_datas() -> void:
	init_cages()

func init_cages() -> void:
	for cage_data in data.table.cages:
		add_cage(cage_data)

func add_cage(data_: CageData) -> void:
	var cage = cage_scene.instantiate()
	cage.data = data_
	cage.museum = self
	%Cages.add_child(cage)
	cages.append(cage)
	cage.active_background.material = ShaderMaterial.new()
	cage.active_background.material.shader = load("uid://f0xra3senpov")

func init_exhibits() -> void:
	for exhibit_data in data.exhibits:
		add_exhibit(exhibit_data)

func add_exhibit(data_: ExhibitData) -> void:
	var exhibit = exhibit_scene.instantiate()
	%Exhibits.add_child(exhibit)
	exhibit.data = data_
	exhibit.museum = self
	var cage_index = int(exhibits.size() * 0.5)
	exhibits.append(exhibit)
	exhibit.cage = cages[cage_index]
#endregion

#region blur
func blur_all() -> void:
	%Blur.visible = true
	%Blur.material.set_shader_parameter("selected_row", -1)
	%Blur.material.set_shader_parameter("selected_col", -1)

func unblur_all() -> void:
	%Blur.visible = false

func unblur_row(index_: int) -> void:
	%Blur.material.set_shader_parameter("selected_row", index_)

func unblur_col(index_: int) -> void:
	%Blur.material.set_shader_parameter("selected_col", index_)
#endregion

func update_sinner_datas() -> void:
	%Cages.visible =  true
	
	for _i in data.sinners.size():
		var sinner_data = data.sinners[_i]
		var cage = cages[_i]
		cage.data.sinner = sinner_data
		cage.sinner.data = sinner_data
		cage.cloak.dream.data = sinner_data.dream
		
		cage.sinner.visible = true
		cage.passive_background.z_index = 1
	
	if %Exhibits.get_child_count() == 0:
		init_exhibits()
	else:
		for _i in data.exhibits.size():
			var exhibit = exhibits[_i]
			var exhibit_data = data.exhibits[_i]
			exhibit.data = exhibit_data

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	#world.inferno.apply_layer()
	unblur_all()
	data.init_sinners()
	await get_tree().process_frame
	update_sinner_datas()
	Scope.weather = Bozo.Weather.SUN
	weather_button.updaet_margin_offset()
	#simulate_choice()

func _input(event: InputEvent) -> void:
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
