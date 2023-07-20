extends MarginContainer


@onready var dicespots = $Dicespots

var sinner = null
var skills = {}
var correct = false


func _ready() -> void:
	while !correct:
		for dicespot in dicespots.get_children():
			dicespots.remove_child(dicespot)
			dicespot.queue_free()
		
		init_dicespots()
	
	correct = false
	
	while !correct:
		clean_dicespots()
		fill_dicespots()


func init_dicespots() -> void:
	correct = false
	var options = []
	options.append_array(Global.dict.specialization.skill[sinner.specialization])
	options.shuffle()
	var balance = Vector2()
	skills.x = {}
	skills.y = {}
	var reverse = {}
	reverse.x =  "y"
	reverse.y =  "x"
	
	for _i in dicespots.columns:
		for _j in dicespots.columns:
			var dicespot = Global.scene.dicespot.instantiate()
			dicespot.workstop = self
			dicespots.add_child(dicespot)
			
			var grid = Vector2(_j, _i)
			dicespot.grid = grid
			
			if grid != Vector2.ZERO and (grid.x == 0 || grid.y == 0) and !skills.has(grid):
				for axis in skills:
					var option = null
					
					if grid[reverse[axis]] == 0:
						if skills[axis].keys().is_empty():
							option = options.pick_random()
							balance[axis] += Global.dict.skill.title[option].balance
							#print([optionaxis, Global.dict.skill.title[option].balance])
						else:
							var d = {}
							d.current = balance[reverse[axis]] - balance[axis]
							var compliants = []
							
							for option_ in options:
								d.new = d.current - Global.dict.skill.title[option_].balance
								
								if abs(d.new) <= 1:
									compliants.append(option_)
							
							if compliants.is_empty():
								return
							
							option = compliants.pick_random()
							balance[axis] += Global.dict.skill.title[option].balance
						
						skills[axis][option] = {}
						skills[axis][option].grid = grid
						skills[axis][option].dicespots = []
						skills[axis][option].correct = null
						skills[axis][option].multiplication = 1
					
					if option != null:
						options.erase(option)
						dicespot.label.text = option
			else:
				if grid != Vector2.ZERO:
					dicespot.value = 0
	
	correct = balance.x == balance.y


func fill_dicespots() -> void:
	var dices = 2
	correct = true
	
	for dicespot in dicespots.get_children():
		if dicespot.value != null:
			var values = {}
			
			for axis in skills:
				var grid = Vector2()
				grid[axis] += dicespot.grid[axis]
				
				for skill in skills[axis]:
					if grid == skills[axis][skill].grid:
						dicespot.skill[axis] = skill
						skills[axis][skill].dicespots.append(dicespot)
						break
			
			values.intersection = []
			
			for axis in dicespot.skill:
				var skill = dicespot.skill[axis]
				var tempo = Global.dict.skill.title[skill].tempo
				values[axis] = []
				values[axis].append_array(Global.dict.multiplication.tempo[tempo].values)

			for value in values.x:
				if values.y.has(value):
					values.intersection.append(value)

			if values.intersection.is_empty():
				values.intersection.append_array(Global.arr.edge)
			
			var value = values.intersection.pick_random()
			dicespot.set_value(value)
	
	adjust_dicespot_values()
	
	for axis in skills:
		for skill in skills[axis]:
			if !skills[axis][skill].correct:
				var node = get_node_by_grid(skills[axis][skill].grid)
				node.bg.visible = true


func clean_dicespots() -> void:
	for dicespot in dicespots.get_children():
		if dicespot.value != null:
			dicespot.value = 0
	
	for axis in skills:
		for skill in skills[axis]:
			skills[axis][skill].dicespots = []


func multiplication_check(axis_: String, skill_: String) -> void:
	var tempo = Global.dict.skill.title[skill_].tempo
	skills[axis_][skill_].correct = Global.dict.multiplication.tempo[tempo].multiplications.has(skills[axis_][skill_].multiplication)


func get_node_by_grid(grid_: Vector2) -> MarginContainer:
	var index = grid_.y * dicespots.columns + grid_.x
	return dicespots.get_child(index)


func adjust_dicespot_values() -> void:
	correct = false
	
	while !correct:
		correct = true
		
		for axis in skills:
			for skill in skills[axis]:
				multiplication_check(axis, skill)
				
				if !skills[axis][skill].correct:
					correct = false
					adjust_skill(axis, skill)


func adjust_skill(axis_: String, skill_: String) -> void:
	var tempo = Global.dict.skill.title[skill_].tempo
	var shift = null
	
	if Global.dict.multiplication.tempo[tempo].min > skills[axis_][skill_].multiplication:
		shift = 1
	elif Global.dict.multiplication.tempo[tempo].max < skills[axis_][skill_].multiplication:
		shift = -1
	
	var dicespot = skills[axis_][skill_].dicespots.pick_random()
	var value = dicespot.value + shift
	dicespot.set_value(value)
	multiplication_check(axis_, skill_)
