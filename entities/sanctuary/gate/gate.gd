class_name Gate
extends Control


@export var cage_scene: PackedScene
@export var catena_scene: PackedScene

@export var world: World

var cages: Array[Cage]
var catenas: Array[Catena]

var vector_to_cage: Dictionary
var vector_to_catena: Dictionary

var active_cages: Array[Cage]
var active_catena: Catena:
	set(value_):
		if active_catena != null:
			active_catena.visible = false
			%SelectButton.visible = false
		active_catena = value_
		
		if active_catena != null:
			pass
			active_catena.visible = true
			active_catena.focus_on_cages()
			%SelectButton.visible = true
		else:
			unblur_all()



#region init
func _ready():
	init_cages()
	update_sinner_datas()

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	size = viewport_size

func init_cages() -> void:
	init_catenas()
	
	for _y in Catalog.JAIL_CAGE_GRID.y:
		for _x in Catalog.JAIL_CAGE_GRID.x:
			var coord = Vector2i(_x, _y)
			add_cage(coord)
	

func init_catenas() -> void:
	for _y in Catalog.JAIL_CAGE_GRID.y:
		var coord = Vector2i(0, _y + 1)
		add_catena(coord, Bozo.Catena.ROW)
	
	for _x in Catalog.JAIL_CAGE_GRID.x:
		var coord = Vector2i(_x + 1, 0)
		add_catena(coord, Bozo.Catena.COL)

func add_catena(coord_: Vector2i, type_: Bozo.Catena) -> void:
	var catena = catena_scene.instantiate()
	%Catenas.add_child(catena)
	catena.setup(self, coord_, type_)
	catenas.append(catena)
	vector_to_catena[coord_] = catena

func add_cage(coord_: Vector2i) -> void:
	var cage = cage_scene.instantiate()
	cage.setup(self, coord_)
	%Cages.add_child(cage)
	cages.append(cage)
	
	var row_coord = Vector2i(0, coord_.y + 1)
	var row_catena = vector_to_catena[row_coord]
	row_catena.cages.append(cage)
	cage.row = row_catena
	
	var col_coord = Vector2i(coord_.x + 1, 0)
	var col_catena = vector_to_catena[col_coord]
	col_catena.cages.append(cage)
	cage.col = col_catena

func update_sinner_datas() -> void:
	for _i in world.data.tribunal.gate.sinners.size():
		var sinner_data = world.data.tribunal.gate.sinners[_i]
		var cage = cages[_i]
		cage.sinner.data = sinner_data
#endregion

func _on_cage_selected(cage_: Cage):
	if !active_cages.is_empty():
		var cage = active_cages.front()
		cage.sinner.fate.unfocus()
	
	if !active_cages.has(cage_):
		active_cages.append(cage_)
		cage_.sinner.fate.focus()
		
		detect_catena()

func detect_catena() -> void:
	while active_cages.size() > 2:
		active_cages.pop_front()
	
	if active_cages.size() != 2: return
	var a = active_cages.front()
	var b = active_cages.back()
	
	if a.col == b.col:
		active_catena = a.col
		return
	
	if a.row == b.row:
		active_catena = a.row
		return
	
	active_cages.pop_front()
	active_catena = null

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
