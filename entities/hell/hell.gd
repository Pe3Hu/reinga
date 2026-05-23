extends Control
class_name Hell


@export var inferno: Inferno
@export var volcano: Volcano
@export var nightmare: Nightmare
@export var jail: Jail
@export var treasury: Treasury

var tribunal = TribunalData.new()


func _ready():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%UI.position = -%UI.size / 2
	inferno.resize_rect(viewport_size)
	jail.next_turn()
	jail.active_cage = treasury.tributes.back().cage
	nightmare._on_lock_button_pressed()
