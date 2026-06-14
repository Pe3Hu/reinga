class_name Abyss
extends Control


var data: AbyssData:
	set(value_):
		data = value_
		init_cages()
		init_catenas()
		init_sacrifices()

@export var cage_scene: PackedScene
@export var catena_scene: PackedScene
@export var sacrifice_scene: PackedScene

@export var world: World
@export var sacrifice_button: CustomButton
@export var weather_button: TextureButton

var cages: Array[Cage]



#region init
func init_cages() -> void:
	for cage_data in data.table.cages:
		add_cage(cage_data)

func init_catenas() -> void:
	for catena_data in data.table.catenas:
		add_catena(catena_data)

func init_sacrifices() -> void:
	for sacrifice_data in data.sacrifices:
		add_sacrifice(sacrifice_data)

func add_sacrifice(data_: SacrificeData) -> void:
	var sacrifice = sacrifice_scene.instantiate()
	sacrifice.data = data_
	sacrifice.abyss = self
	%Sacrifices.add_child(sacrifice)

func add_catena(data_: CatenaData) -> void:
	var catena = catena_scene.instantiate()
	catena.data = data_
	catena.abyss = self
	%Catenas.add_child(catena)

func add_cage(data_: CageData) -> void:
	var cage = cage_scene.instantiate()
	cage.data = data_
	cage.abyss = self
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
		cage.data.sinner = sinner_data
		cage.sinner.data = sinner_data
		cage.cloak.dream.data = sinner_data.dream
		
		cage.sinner.visible = true
		cage.passive_background.z_index = 1
	
	update_sacrifices()
	
func update_sacrifices() -> void:
	#for _i in %Catenas.get_child_count():
		#var catena = %Catenas.get_child(_i)
		#var sacrifice = %Sacrifices.get_child(_i)
		#sacrifice.position = catena.position
		#sacrifice.size = catena.size
	
	data.update_sacrifice_ambers()

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	world.inferno.apply_layer()
	unblur_all()
	data.init_sinners()
	update_sinner_datas()
	Scope.weather = Bozo.Weather.SUN
	weather_button.updaet_margin_offset()
	#simulate_choice()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not %Panel.get_global_rect().has_point(get_global_mouse_position()):
				if !sacrifice_button.is_mouse_inside():
					forget_catenas()

func forget_catenas() -> void:
	if Scope.layer == Bozo.Layer.ABYSS:
		data.table.reset_cage()
		data.table.reset_catenas()
		unblur_all()

func simulate_choice() -> void:
	await get_tree().create_timer(0.3).timeout
	var catena = data.table.catenas.back()
	catena.is_selected = true
	sacrifice_button._on_pressed()

func apply_weather() -> void:
	for cage in cages:
		cage.apply_weather()
