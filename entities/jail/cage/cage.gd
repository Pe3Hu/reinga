extends Area2D
class_name Cage


var jail: Jail
var coord: Vector2i

var status: Bozo.Cage:
	set(value_):
		status = value_
		%BorderSprite.modulate = Catalog.cage_to_color[status]

var col: Catena
var row: Catena


func setup(jail_: Jail, coord_: Vector2i):
	jail = jail_
	coord = coord_ 
	position = Vector2(coord) * Catalog.CAGE_SPRITE_SIZE

func highligh() -> void:
	jail.reset_cages()
	jail.active_cage = self
	row.highligh_cages()
	col.highligh_cages()
	jail.update_cages()

func _input_event(_viewport, event_, _shape_idx):
	if event_ is InputEventMouseButton and event_.pressed:
		EventBus.cage_selected.emit(self)
