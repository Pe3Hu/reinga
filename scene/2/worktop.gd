extends MarginContainer


@onready var dicespots = $Dicespots

var sinner = null
var skills = {}
var corrent = false


func _ready() -> void:
	while !corrent:
		for dicespot in dicespots.get_children():
			dicespots.remove_child(dicespot)
			dicespot.queue_free()
		
		init_dicespots()
	
	corrent = false
	
	while !corrent:
		clean_dicespots()
		fill_dicespots()


func init_dicespots() -> void:
	corrent = false
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
			
			var grid = Vector2(_i, _j)
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
						skills[axis][option].values = []
					
					if option != null:
						options.erase(option)
						dicespot.label.text = option
			else:
				if grid != Vector2.ZERO:
					dicespot.value = 0
	
	corrent = balance.x == balance.y


func fill_dicespots() -> void:
	var dices = 2
	corrent = true
	
	for dicespot in dicespots.get_children():
		if dicespot.value != null:
			var values = {}
			
			for axis in skills:
				var grid = Vector2()
				grid[axis] += dicespot.grid[axis]
				
				for skill in skills[axis]:
					if grid == skills[axis][skill].grid:
						dicespot.skill[axis] = skill
						break
			
			values.intersection = []
			
			for axis in dicespot.skill:
				var skill = dicespot.skill[axis]
				var tempo = Global.dict.skill.title[skill].tempo
				values[axis] = []
				
				if !skills[axis][skill].values.is_empty():
					values.appropriate = []
					
					for multiplication in Global.dict.multiplication.tempo[tempo].multiplications:
						for appropriate in Global.dict.multiplication.all[multiplication]:
							for value in multiplication:
								if skills[axis][skill].values.has(value):
									values.appropriate.append(appropriate)
				
					for value in skills[axis][skill].values:
						for appropriate in values.appropriate:
							appropriate.erase(value)
					
					for appropriate in values.appropriate:
						if dices == appropriate.size() + skills[axis][skill].values.size():
							for value in appropriate:
								if !values[axis].has(value):
									values[axis].append(value)
				
					if values[axis].is_empty():
						corrent = false
						return
				else:
					values[axis].append_array(Global.dict.multiplication.tempo[tempo].values)
			
			for value in values.x:
				if values.y.has(value):
					values.intersection.append(value)
			
			if values.intersection.is_empty():
				corrent = false
				return
			else:
				dicespot.value = values.intersection.pick_random()
				for axis in dicespot.skill: 
					var skill = dicespot.skill[axis]
					skills[axis][skill].values.append(dicespot.value)
				
				dicespot.label.text = str(dicespot.value)


func clean_dicespots() -> void:
	for dicespot in dicespots.get_children():
		if dicespot.value != null:
			dicespot.value = 0
	
	for axis in skills:
		for skill in skills[axis]:
			skills[axis][skill].values = []
