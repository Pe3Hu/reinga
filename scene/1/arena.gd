extends MarginContainer


@onready var hbox = $HBox
@onready var dices = $HBox/Dices

func _ready() -> void:
	add_team("Left")
	add_team("Right")
	hbox.move_child(dices, 1)
	


func add_team(side_: String) -> void:
	var team = Global.node.hell.get_team_in_queue()
	team.set_side(side_)
	team.arena = self
	hbox.add_child(team)
