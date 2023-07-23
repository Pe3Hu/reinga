extends MarginContainer


@onready var hbox = $HBox
@onready var vbox = $HBox/VBox
@onready var dices = $HBox/VBox/Dices

var teams = []
var initiatives = []
var iniative_counter = 0


func _ready() -> void:
	add_team("Left")
	add_team("Right")
	hbox.move_child(vbox, 1)
	
	arena_preparation()
	#dices.roll_dices()


func add_team(side_: String) -> void:
	var team = Global.node.hell.get_team_in_queue()
	team.set_side(side_)
	team.arena = self
	hbox.add_child(team)
	teams.append(team)


func arena_preparation() -> void:
	set_initiatives()
	set_foes()


func set_initiatives() -> void:
	var datas = {}
	
	for team in teams:
		for sinner in team.sinners.get_children():
			if !datas.has(sinner.initiative):
				datas[sinner.initiative] = []
			
			datas[sinner.initiative].append(sinner)
	
	for initiative in datas:
		datas[initiative].shuffle()
		
		for sinner in datas[initiative]:
			initiatives.append(sinner)


func set_foes() -> void:
	for team in teams:
		for sinner in team.sinners.get_children():
			for foe in initiatives:
				if foe.team != sinner.team:
					sinner.foes.append(foe)


func round_preparation() -> void:
	dices.roll_dices()


func make_round() -> void:
	round_preparation()
	fills_dicespots_one_by_one()


func fills_dicespots_one_by_one() -> void:
	while iniative_counter < initiatives.size():
		var sinner = initiatives[iniative_counter]
		sinner.fills_dicespots()
		iniative_counter += 1
	
	iniative_counter = 0


func close() -> void:
	var winner = initiatives.front().team
	
	for sinner in winner.sinners.get_children():
		print(sinner.specialization, " is winner")
