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
@export var select_button: Button
@export var reset_timer: Timer

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

func update_sinner_datas() -> void:
	%Cages.visible =  true
	
	for _i in data.sinners.size():
		var sinner_data = data.sinners[_i]
		var cage = cages[_i]
		
		if cage.data.sinner != sinner_data:
			cage.data.sinner = sinner_data
		
		if cage.sinner.data != sinner_data:
			cage.sinner.data = sinner_data
		
		if cage.cloak.dream.data != sinner_data.dream:
			cage.cloak.dream.data = sinner_data.dream
		
		cage.sinner.visible = true

func open() -> void:
	if !data.is_open: return

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	unblur_all()
	data.init_fates()
	update_sinner_datas()


func _on_select_button_pressed() -> void:
	data.refill_tribunal()
	world.transition.data.next_layer = Bozo.Layer.HELL

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not %Panel.get_global_rect().has_point(get_global_mouse_position()):
				
				reset_timer.start()

func _on_reset_timer_timeout() -> void:
	if Scope.layer == Bozo.Layer.GATE:
		forget_catenas()
	else:
		reset_timer.stop()

func forget_catenas() -> void:
	data.table.reset_cage()
	data.table.reset_catenas()
	unblur_all()
