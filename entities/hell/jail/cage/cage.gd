extends PanelContainer
class_name Cage


var jail: Jail
@export var sinner: Sinner
@export var cloak: Cloak

var coord: Vector2i

var status: Bozo.Cage = Bozo.Cage.NONE:
	set(value_):
		status = value_
		
		sinner.reset_blur()
		var traits = Catalog.cage_to_traits[status]
		
		for _trait in traits:
			sinner.select_trait(_trait)

var col: Catena
var row: Catena
var tribute: Tribute


func setup(jail_: Jail, coord_: Vector2i):
	jail = jail_
	coord = coord_ 
	position = Vector2(coord) * Catalog.CAGE_SIZE

func highligh() -> void:
	jail.reset_cages()
	row.highligh_cages()
	col.highligh_cages()
	jail.update_cages()
	status = Bozo.Cage.CENTER

func switch_side() -> void:
	sinner.visible = !sinner.visible
	cloak.visible = !cloak.visible

func _on_texture_button_pressed() -> void:
	jail._on_cage_selected(self)
