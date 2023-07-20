extends MarginContainer


@onready var worktops = $HBox/Worktops
@onready var indicators = $HBox/Indicators

var team = null
var skills = []
var specialization = null


func _ready() -> void:
	init_wortops()
	indicators.label.text = specialization
	indicators.sinner = self


func init_wortops() -> void:
	var n = 2
	
	for _i in n:
		var worktop = Global.scene.worktop.instantiate()
		worktop.sinner = self
		worktops.add_child(worktop)
