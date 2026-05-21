extends PanelContainer
class_name Jail


@export var cage_scene: PackedScene
@export var catena_scene: PackedScene

@export var hell: Hell
@export var cages: GridContainer
@export var catenas: Control

var vector_to_cage: Dictionary
var vector_to_catena: Dictionary

var active_cage: Cage:
	set(value_):
		if active_cage != null:
			active_cage.tribute.border.visible = false
		
		active_cage = value_
		
		if active_cage != null:
			active_cage.tribute.border.visible = true


func _ready():
	EventBus.cage_selected.connect(_on_cage_selected)
	init_cages()

func init_cages() -> void:
	init_catenas()
	
	for _y in Catalog.JAIL_CAGE_SIZE.y:
		for _x in Catalog.JAIL_CAGE_SIZE.x:
			var coord = Vector2i(_x, _y)
			add_cage(coord)

func init_catenas() -> void:
	for _y in Catalog.JAIL_CAGE_SIZE.y:
		var coord = Vector2i(0, _y + 1)
		add_catena(coord, Bozo.Catena.ROW)
	
	for _x in Catalog.JAIL_CAGE_SIZE.x:
		var coord = Vector2i(_x + 1, 0)
		add_catena(coord, Bozo.Catena.COL)

func add_catena(coord_: Vector2i, type_: Bozo.Catena) -> void:
	var catena = catena_scene.instantiate()
	catena.setup(self, coord_, type_)
	catenas.add_child(catena)
	vector_to_catena[coord_] = catena

func add_cage(coord_: Vector2i) -> void:
	var cage = cage_scene.instantiate()
	cage.setup(self, coord_)
	cages.add_child(cage)
	
	var row_coord = Vector2i(0, coord_.y + 1)
	var row_catena = vector_to_catena[row_coord]
	row_catena.cages.append(cage)
	cage.row = row_catena
	
	var col_coord = Vector2i(coord_.x + 1, 0)
	var col_catena = vector_to_catena[col_coord]
	col_catena.cages.append(cage)
	cage.col = col_catena

func _on_cage_selected(cage_: Cage):
	active_cage = cage_
	active_cage.highligh()

func reset_cages() -> void:
	for cage in cages.get_children():
		cage.status = Bozo.Cage.NONE

func update_cages() -> void:
	var col_index = active_cage.coord.x
	
	for cage in cages.get_children():
		if cage.status != Bozo.Cage.MIDDLE:
			if cage.coord.x < col_index:
				cage.status = Bozo.Cage.LEFT
			
			if cage.coord.x > col_index:
				cage.status = Bozo.Cage.RIGHT

func next_turn() -> void:
	hell.tribunal.refill_actual()
	
	for _i in hell.tribunal.actual.sinners.size():
		var sinner_data = hell.tribunal.actual.sinners[_i]
		var cage = cages.get_child(_i)
		cage.sinner.data = sinner_data
	
	hell.treasury.update_tributes()
