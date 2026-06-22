class_name Gate
extends Control


var data: GateData:
	set(value_):
		data = value_
		init_cages()
		init_catenas()

@export var cage_scene: PackedScene
@export var catena_scene: PackedScene

@export var world: World
@export var shackle_button: Button
@export var weather_button: TextureButton

var cages: Array[Cage]


#region init
func init_cages() -> void:
	for cage_data in data.table.cages:
		add_cage(cage_data)

func init_catenas() -> void:
	for catena_data in data.table.catenas:
		add_catena(catena_data)

func add_catena(data_: CatenaData) -> void:
	var catena = catena_scene.instantiate()
	catena.data = data_
	catena.gate = self
	%Catenas.add_child(catena)

func add_cage(data_: CageData) -> void:
	var cage = cage_scene.instantiate()
	cage.data = data_
	cage.gate = self
	%Cages.add_child(cage)
	cages.append(cage)
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
		
		if cage.data.sinner != sinner_data:
			cage.data.sinner = sinner_data
			cage.sinner.data = sinner_data
		
		if cage.cloak.dream.data != sinner_data.dream:
			cage.cloak.dream.data = sinner_data.dream
		
		cage.sinner.visible = true
		cage.passive_background.z_index = 1
		cage.sinner.soul.show_all()

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	unblur_all()
	data.init_fates()
	update_sinner_datas()
	Scope.weather = Bozo.Weather.SUN
	weather_button.updaet_margin_offset()
	simulate_choice()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not %Panel.get_global_rect().has_point(get_global_mouse_position()):
				if !shackle_button.is_mouse_inside():
					forget_catenas()

func forget_catenas() -> void:
	if Scope.layer == Bozo.Layer.GATE:
		data.table.reset_cage()
		data.table.reset_catenas()
		unblur_all()

func simulate_choice() -> void:
	var duration = Gear.simulates[Gear.tempo] * 0.5
	await get_tree().create_timer(duration).timeout
	var catena = data.table.catenas.back()
	data.table._on_cage_gate_selected(catena.cages.front())
	await get_tree().create_timer(duration).timeout
	data.table._on_cage_gate_selected(catena.cages.back())
	shackle_button._button_pressed()

func apply_weather() -> void:
	for cage in cages:
		cage.apply_weather()
