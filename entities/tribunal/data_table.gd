class_name TableData
extends Resource


var jail: JailData
var gate: GateData
var cages: Array[CageData]
var catenas: Array[CatenaData]

var vector_to_cage: Dictionary
var vector_to_catena: Dictionary

var active_catenas: Array[CatenaData]
var active_cages: Array[CageData]


#region init
func _init() -> void:
	init_catenas()
	init_cages()

func init_cages() -> void:
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
	var catena = CatenaData.new(self, coord_, type_)
	catenas.append(catena)
	vector_to_catena[coord_] = catena

func add_cage(coord_: Vector2i) -> void:
	var cage = CageData.new(self, coord_)
	cages.append(cage)
	
	var row_coord = Vector2i(0, coord_.y + 1)
	var row_catena = vector_to_catena[row_coord]
	row_catena.cages.append(cage)
	cage.row = row_catena
	
	var col_coord = Vector2i(coord_.x + 1, 0)
	var col_catena = vector_to_catena[col_coord]
	col_catena.cages.append(cage)
	cage.col = col_catena
#endregion

#region select
func _on_cage_gate_selected(cage_: CageData):
	if !active_cages.has(cage_):
		active_cages.append(cage_)
		cage_.sinner.fate.is_selected = true
	
	detect_catena()
	reset_cage()

func reset_cage(is_all_: bool = false) -> void:
	if active_cages.size() > 1:
		unselect_cage()
	if is_all_:
		unselect_cage()

func unselect_cage() -> void:
	if !active_cages.is_empty():
		var cage = active_cages.pop_front()
		cage.sinner.fate.is_selected = false

func detect_catena() -> void:
	while active_cages.size() > 2:
		active_cages.pop_front()
	
	if active_cages.size() != 2: return
	var a = active_cages.front()
	var b = active_cages.back()
	reset_catenas()
	
	if a.col == b.col:
		a.col.is_selected = true
		return
	
	if a.row == b.row:
		a.row.is_selected = true
		return
	
	a.sinner.fate.is_selected = false
	active_cages.pop_front()

func reset_cages() -> void:
	while !active_cages.is_empty():
		unselect_cage()
	
	for cage in cages:
		if cage.sinner:
			cage.sinner.fate.is_selected = false
	

func reset_catenas() -> void:
	for catena in catenas:
		catena.is_selected = false

func reset_all_actives() -> void:
	reset_catenas()
	reset_cages()

func _on_cage_jail_selected(cage_: CageData):
	if !active_cages.has(cage_):
		reset_catenas()
		active_cages.append(cage_)
		cage_.sinner.fate.is_selected = true
		
		cage_.col.is_selected = true
		cage_.row.is_selected = true
	
	reset_cage()
#endregion
