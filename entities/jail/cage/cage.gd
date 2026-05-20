extends PanelContainer
class_name Cage


var jail: Jail
var sinner: Sinner
var coord: Vector2i

var status: Bozo.Cage:
	set(value_):
		status = value_
		%Highlight.modulate = Catalog.cage_to_color[status]
		%Highlight.texture = load("res://entities/sinner/images/%s.png" % [Catalog.cage_to_string[status]])

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
	status = Bozo.Cage.CENTER

func _on_texture_button_pressed() -> void:
	EventBus.cage_selected.emit(self)
