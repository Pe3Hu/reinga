extends MarginContainer


@onready var worktops = $Worktops

var team = null
var skills = []
var specialization = null


func _ready() -> void:
	init_wortops()


func init_wortops() -> void:
	var n = 2
	
	for _i in n:
		var worktop = Global.scene.worktop.instantiate()
		worktop.sinner = self
		worktops.add_child(worktop)


func set_specialization(specialization_) -> void:
	specialization = specialization_
