extends PanelContainer
class_name Cage


var jail: Jail
var gate: Gate
@export var sinner: Sinner
@export var cloak: Cloak

var type: Bozo.Tooltip = Bozo.Tooltip.CAGE
var coord: Vector2i

var status: Bozo.Cage = Bozo.Cage.NONE:
	set(value_):
		status = value_
		
		sinner.soul.reset_blur()
		var traits = Catalog.cage_to_traits[status]
		
		for _trait in traits:
			sinner.soul.select_trait(_trait)

var col: Catena
var row: Catena
var contribution: Contribution


func setup(owner_: Variant, coord_: Vector2i):
	if owner_ is Jail:
		jail = owner_
	if owner_ is Gate:
		gate = owner_
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
	if jail:
		jail._on_cage_selected(self)
	if gate:
		gate._on_cage_selected(self)
		
