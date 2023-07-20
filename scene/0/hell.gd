extends MarginContainer


@onready var teams_queue = $Teams/Queue
@onready var arenas = $Arenas


func _ready() -> void:
	init_teams()
	init_arena()


func init_teams() -> void:
	var n = 2
	
	for _i in n:
		var team = Global.scene.team.instantiate()
		teams_queue.add_child(team)
		
		var specialization = Global.dict.specialization.skill.keys()[_i]
		var sinner = Global.scene.sinner.instantiate()
		sinner.specialization = specialization
		sinner.team = team
		team.sinners.add_child(sinner)


func init_arena() -> void:
	var arena = Global.scene.arena.instantiate()
	arenas.add_child(arena)


func get_team_in_queue() -> MarginContainer:
	var team = teams_queue.get_children().front()
	teams_queue.remove_child(team)
	return team
