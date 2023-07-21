extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]


func init_num() -> void:
	num.index = {}


func init_dict() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]
	
	dict.specialization = {}
	dict.specialization.skill = {}
	
	
	init_multiplications()
	init_skills()
	init_permutations()


func init_multiplications() -> void:
	dict.multiplication = {}
	dict.multiplication.tempo = {}
	dict.multiplication.tempo["fast"] = {}
	dict.multiplication.tempo["normal"] = {}
	dict.multiplication.tempo["slow"] = {}
	
	dict.multiplication.tempo["fast"].balance = 1
	dict.multiplication.tempo["normal"].balance = 0
	dict.multiplication.tempo["slow"].balance = -1
	
	dict.multiplication.tempo["fast"].min = 24
	dict.multiplication.tempo["normal"].min = 12
	dict.multiplication.tempo["slow"].min = 1
	
	dict.multiplication.tempo["fast"].max = 36
	dict.multiplication.tempo["normal"].max = 20
	dict.multiplication.tempo["slow"].max = 10
	
	dict.multiplication.all = {}
	
	for _i in range(1, 7, 1):
		for _j in range(1, 7, 1):
			var multiplication = _i * _j
			
			if !dict.multiplication.all.has(multiplication):
				dict.multiplication.all[multiplication] = []
			
			var permutations = [_i, _j]
			
			if !dict.multiplication.all[multiplication].has(permutations):
				dict.multiplication.all[multiplication].append(permutations)
	
	for tempo in dict.multiplication.tempo:
		dict.multiplication.tempo[tempo].permutations = []
		dict.multiplication.tempo[tempo].multiplications = []
		
		for multiplication in range(dict.multiplication.tempo[tempo].min, dict.multiplication.tempo[tempo].max + 1, 1):
			if dict.multiplication.all.has(multiplication):
				dict.multiplication.tempo[tempo].multiplications.append(multiplication)
				for permutations in dict.multiplication.all[multiplication]:
					for permutation in permutations:
						if !dict.multiplication.tempo[tempo].permutations.has(permutation):
							dict.multiplication.tempo[tempo].permutations.append(permutation)
		
		#for multiplication in dict.multiplication.tempo[tempo].multiplications:
		#	print(tempo, dict.multiplication.all[multiplication])
		#print(tempo, dict.multiplication.tempo[tempo].permutations)


func init_skills() -> void:
	dict.skill = {}
	dict.skill.title = {}
	var path = "res://asset/json/reinga_skill.json"
	var array = load_data(path)
	
	for data in array:
		dict.skill.title[data.title] = data
		dict.skill.title[data.title].balance = dict.multiplication.tempo[data.tempo].balance
		
		if !dict.specialization.skill.has(data.specialization):
			dict.specialization.skill[data.specialization] = []
		
		dict.specialization.skill[data.specialization].append(data.title)
		dict.skill.title[data.title].erase("title")


func init_permutations() -> void:
	dict.sum = {}
	dict.sum.permutation = {}
	dict.permutation = {}
	dict.permutation.sum = {}
	
	for _i in arr.edge:
		for _j in arr.edge:
			var sum = _i + _j
			
			if !dict.sum.permutation.has(sum):
				dict.sum.permutation[sum] = 0
			
			dict.sum.permutation[sum] += 1
	
	for sum in dict.sum.permutation:
		var permutation = dict.sum.permutation[sum]
		
		if !dict.permutation.sum.has(permutation):
			dict.permutation.sum[permutation] = []
		
		dict.permutation.sum[permutation].append(sum)


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.hell = load("res://scene/0/hell.tscn")
	scene.arena = load("res://scene/1/arena.tscn")
	scene.team = load("res://scene/1/team.tscn")
	scene.sinner = load("res://scene/2/sinner.tscn")
	scene.worktop = load("res://scene/2/worktop.tscn")
	scene.dicespot = load("res://scene/2/dicespot.tscn")
	scene.cell = load("res://scene/3/cell.tscn")
	scene.dice = load("res://scene/4/dice.tscn")


func init_vec():
	vec.size = {}
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0, 1, 0.9)
	color.indicator.health.background = Color.from_hsv(0, 0.25, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(0.33, 1, 0.9)
	color.indicator.endurance.background = Color.from_hsv(0.33, 0.25, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()
