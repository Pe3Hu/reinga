extends MarginContainer


@onready var dicespots = $Dicespots

var sinner = null
var skills = {}

func _ready() -> void:
	init_dicespots()


func init_dicespots() -> void:
	var options = []
	var a = Global.dict.specialization.skill
	var b = sinner.specialization
	var c = sinner.specialization
	options.append_array(Global.dict.specialization.skill[sinner.specialization])
	
	for _i in dicespots.columns:
		for _j in dicespots.columns:
			var dicespot = Global.scene.dicespot.instantiate()
			dicespot.workstop = self
			dicespots.add_child(dicespot)
			
			var grid = Vector2(_i, _j)
			
			if grid != Vector2.ZERO and (grid.x == 0 || grid.y == 0) and !skills.has(grid):
				skills[grid] = options.pick_random()
				options.erase(skills[grid])
				dicespot.label.text = skills[grid]
