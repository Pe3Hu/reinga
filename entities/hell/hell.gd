extends Control
class_name Hell


@export var volcano: Volcano
@export var nightmare: Nightmare
@export var jail: Jail
@export var treasury: Treasury

var tribunal = TribunalData.new()


func _ready():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%HBox.position = -%HBox.size / 2
	jail.next_turn()
	#jail.active_cage = jail.cages.get_child(0)
	#nightmare._on_lock_button_pressed()
