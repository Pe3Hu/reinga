class_name TableData
extends Resource


var abyss: AbyssData
var gate: GateData
var jail: JailData:
	set(value_):
		jail = value_
		jail_extensions()

var cages: Array[CageData]
var catenas: Array[CatenaData]
var special_catenas: Array[CatenaData]

var coord_to_cage: Dictionary
var coord_to_catena: Dictionary

var active_catenas: Array[CatenaData]
var active_cages: Array[CageData]


#region init
func _init() -> void:
	init_catenas()
	init_cages()

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
	coord_to_catena[coord_] = catena

func init_cages() -> void:
	for _y in Catalog.JAIL_CAGE_GRID.y:
		for _x in Catalog.JAIL_CAGE_GRID.x:
			var coord = Vector2i(_x, _y)
			add_cage(coord)
	
	init_cage_neighbours()

func add_cage(coord_: Vector2i) -> void:
	var cage = CageData.new(self, coord_)
	cages.append(cage)
	coord_to_cage[coord_] = cage
	
	var row_coord = Vector2i(0, coord_.y + 1)
	var row_catena = coord_to_catena[row_coord]
	row_catena.cages.append(cage)
	cage.row = row_catena
	
	var col_coord = Vector2i(coord_.x + 1, 0)
	var col_catena = coord_to_catena[col_coord]
	col_catena.cages.append(cage)
	cage.col = col_catena

func init_cage_neighbours() -> void:
	for cage in cages:
		for direction in Catalog.neighbours_coords:
			var coord = cage.coord + direction
			if coord_to_cage.has(coord):
				var neighbour = coord_to_cage[coord]
				cage.neighbours.append(neighbour)
		
		cage.destiny = Catalog.neighbour_to_destiny[cage.neighbours.size()]

func jail_extensions() -> void:
	var coord = Vector2i(1, 1)
	var type = Bozo.Catena.DIAGONAL
	add_special_catena(coord, type)
	coord = Vector2i(-1, 1)
	add_special_catena(coord, type)

func add_special_catena(coord_: Vector2i, type_: Bozo.Catena) -> void:
	var catena = CatenaData.new(self, coord_, type_)
	special_catenas.append(catena)
	
	var cage_grid = Vector2i(0, 0)
	
	if coord_ == Vector2i(-1, 1):
		cage_grid = Vector2i(2, 0)
	
	for _i in Catalog.JAIL_CAGE_GRID.x:
		var cage = coord_to_cage[cage_grid]
		catena.cages.append(cage)
		cage_grid += coord_
#endregion

#region select
func _on_cage_gate_selected(cage_: CageData) -> void:
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
		if cage.table.jail:
			cage.table.jail.platform.undo_immature_cage(cage)
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

func reset_catenas(is_locked_: bool = false) -> void:
	if is_locked_:
		var cage = active_cages.back()
		#cage.fruit = Bozo.Fruit.IMMATURE
		jail.platform.immatures.append(cage)
	
	for catena in catenas:
		catena.is_selected = false

func reset_all_actives() -> void:
	reset_catenas()
	reset_cages()

func _on_cage_jail_selected(cage_: CageData) -> void:
	if !active_cages.has(cage_):
		reset_catenas()
		active_cages.append(cage_)
		cage_.sinner.fate.is_selected = true
		
		cage_.col.is_selected = true
		cage_.row.is_selected = true
	
	reset_cage()

func _on_cage_abyss_selected(cage_: CageData) -> void:
	if !active_cages.has(cage_):
		active_cages.append(cage_)
		cage_.sinner.fate.is_selected = true
	
	detect_catena()
	reset_cage()
#endregion
