extends PanelContainer
class_name Jail


var data: JailData:
	set(value_):
		data = value_
		init_cages()
		init_catenas()

@export var cage_scene: PackedScene
@export var catena_scene: PackedScene

@export var hell: Hell

var cages: Array[Cage]


#region init
func init_cages() -> void:
	cages.clear()
	for cage_data in data.table.cages:
		add_cage(cage_data)

func init_catenas() -> void:
	for catena_data in data.table.catenas:
		add_catena(catena_data)

func add_catena(data_: CatenaData) -> void:
	var catena = catena_scene.instantiate()
	catena.data = data_
	%Catenas.add_child(catena)

func add_cage(data_: CageData) -> void:
	var cage = cage_scene.instantiate()
	cage.data = data_
	cage.jail = self
	%Cages.add_child(cage)
	cages.append(cage)
#endregion

func update_sinner_datas() -> void:
	for _i in hell.world.data.tribunal.actual.sinners.size():
		var sinner_data = hell.world.data.tribunal.actual.sinners[_i]
		var cage = cages[_i]
		cage.data.sinner = sinner_data
		cage.sinner.data = sinner_data
		cage.cloak.dream.data = sinner_data.dream

func apply_phase_visiblity() -> void:
	%Cages.visible = true
	
	match Scope.phase:
		Bozo.Phase.DISBURSEMENT:
			%Cages.visible = false

func get_active_cage() ->  Variant:
	for cage in cages:
		if cage.data == data.table.active_cage:
			return cage
	return null



func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not get_global_rect().has_point(get_global_mouse_position()):
				data.table.reset_cage()
