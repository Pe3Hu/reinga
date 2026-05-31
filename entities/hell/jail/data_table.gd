class_name TableData
extends Resource


var world: WorldData
var cages: Array[CageData]
var catenas: Array[CatenaData]

var vector_to_cage: Dictionary
var vector_to_catena: Dictionary

var active_cages: Array[CageData]
#var active_cage: CageData:
	#set(value_):
		#if is_locked: return
		##if active_cage != null:
			##active_cage.contribution.border.visible = false
			##active_cage.sinner.fate.unfocus()
			##active_cage.col.visible = false
			##active_cage.row.visible = false
			##hell.treasury.lock_button.visible = false
		#
		#active_cage = value_
		#
		##if active_cage != null:
			##active_cage.contribution.border.visible = true
			##active_cage.sinner.fate.focus()
			##active_cage.col.visible = true
			##active_cage.row.visible = true
			##hell.treasury.lock_button.visible = true
#
#var active_catena: Catena:
	#set(value_):
		##if active_catena != null:
			##active_catena.visible = false
			##%SelectButton.visible = false
		#
		#active_catena = value_
		#
		##if active_catena != null:
			##pass
			##active_catena.visible = true
			##active_catena.focus_on_cages()
			##%SelectButton.visible = true
		##else:
			##unblur_all()

var is_locked: bool = false:
	set(value_):
		is_locked = value_
		
		#if is_locked:
		#	hell.treasury.sort_icon.visible = false


func _init(world_: WorldData) -> void:
	world = world_
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

func _on_cage_selected(cage_: CageData):
	reset_cage()
	
	if !active_cages.has(cage_):
		active_cages.append(cage_)
		cage_.sinner.fate.is_selected = true
		#cage_.sinner.fate.is_seleted = true
		
		#detect_catena()

func reset_cage() -> void:
	if !active_cages.is_empty():
		var cage = active_cages.pop_front()
		cage.sinner.fate.is_selected = false
