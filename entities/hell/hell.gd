extends Control
class_name Hell


@export var jail: Jail
@export var treasury: Treasury

var tribunal = TribunalData.new()


func _ready():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%HBox.position = -Vector2(Catalog.JAIL_CAGE_GRID) * Catalog.CAGE_SIZE / 2
	
	jail.next_turn()
