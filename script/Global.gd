extends Node


var rng = RandomNumberGenerator.new()
var num = {}
var dict = {}
var arr = {}
var obj = {}
var node = {}
var flag = {}
var vec = {}
var scene = {}
var stats = {}


func _ready() -> void:
	init_num()
	init_dict()
	init_arr()
	init_node()
	init_scene()
	init_vec()


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
	init_skill()


func init_skill() -> void:
	dict.skill = {}
	dict.skill.title = {}
	var path = "res://asset/json/reinga_skill.json"
	var array = load_data(path)
	
	for data in array:
		dict.skill.title[data.title] = data
		
		if !dict.specialization.skill.has(data.specialization):
			dict.specialization.skill[data.specialization] = []
		
		dict.specialization.skill[data.specialization].append(data.title)
		dict.skill.title[data.title].erase("title")
	
	print(dict.specialization.skill)


func init_arr() -> void:
	pass


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.hell = load("res://scene/0/hell.tscn")
	scene.arena = load("res://scene/1/arena.tscn")
	scene.team = load("res://scene/1/team.tscn")
	scene.sinner = load("res://scene/2/sinner.tscn")
	scene.worktop = load("res://scene/2/worktop.tscn")
	scene.dicespot = load("res://scene/2/dicespot.tscn")
	


func init_vec():
	vec.size = {}
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


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
