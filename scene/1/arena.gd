extends MarginContainer


@onready var teams = $Teams


func _ready() -> void:
	add_team("Left")
	add_team("Right")


func add_team(side_: String) -> void:
	var team = Global.node.hell.get_team_in_queue()
	print(1, team)
	team.set_side(side_)
	team.arena = self
	teams.add_child(team)
