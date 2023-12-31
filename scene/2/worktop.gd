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
	options.append_array(sinner.skills.studied)
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
					var skill = null
					
					if grid[reverse[axis]] == 0:
						if skills[axis].keys().is_empty():
							skill = options.pick_random()
							balance[axis] += Global.dict.skill.title[skill].balance
							#print([optionaxis, Global.dict.skill.title[option].balance])
						else:
							var d = {}
							d.current = balance[reverse[axis]] - balance[axis]
							var compliants = []
							
							for option in options:
								d.new = d.current - Global.dict.skill.title[option].balance
								
								if abs(d.new) <= 1:
									compliants.append(option)
							
							if compliants.is_empty():
								return
							
							skill = compliants.pick_random()
							balance[axis] += Global.dict.skill.title[skill].balance
						
						skills[axis][skill] = {}
						skills[axis][skill].grid = grid
						skills[axis][skill].dicespots = []
						skills[axis][skill].correct = null
						skills[axis][skill].multiplication = 1
					
					if skill != null:
						options.erase(skill)
						dicespot.label.text = skill
						if !sinner.skills.used.has(skill):
							sinner.skills.used.append(skill)
			else:
				if grid != Vector2.ZERO:
					dicespot.permutation = 0
	
	correct = balance.x == balance.y


func fill_dicespots() -> void:
	var dices = 2
	correct = true
	
	for dicespot in dicespots.get_children():
		if dicespot.permutation != null:
			var permutations = {}
			
			for axis in skills:
				var grid = Vector2()
				grid[axis] += dicespot.grid[axis]
				
				for skill in skills[axis]:
					if grid == skills[axis][skill].grid:
						dicespot.skills[axis] = skill
						skills[axis][skill].dicespots.append(dicespot)
						break
			
			permutations.intersection = []
			
			for axis in dicespot.skills:
				var skill = dicespot.skills[axis]
				var tempo = Global.dict.skill.title[skill].tempo
				permutations[axis] = []
				permutations[axis].append_array(Global.dict.multiplication.tempo[tempo].permutations)

			for permutation in permutations.x:
				if permutations.y.has(permutation):
					permutations.intersection.append(permutation)

			if permutations.intersection.is_empty():
				permutations.intersection.append_array(Global.arr.edge)
			
			var permutation = permutations.intersection.pick_random()
			dicespot.set_permutation(permutation)
	
	adjust_dicespot_permutations()
	set_dicespots_sums()


func clean_dicespots() -> void:
	for dicespot in dicespots.get_children():
		if dicespot.permutation != null:
			dicespot.permutation = 0
	
	for axis in skills:
		for skill in skills[axis]:
			skills[axis][skill].dicespots = []


func multiplication_check(axis_: String, skill_: String) -> void:
	var tempo = Global.dict.skill.title[skill_].tempo
	skills[axis_][skill_].correct = Global.dict.multiplication.tempo[tempo].multiplications.has(skills[axis_][skill_].multiplication)


func get_node_by_grid(grid_: Vector2) -> MarginContainer:
	var index = grid_.y * dicespots.columns + grid_.x
	return dicespots.get_child(index)


func adjust_dicespot_permutations() -> void:
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
	
	if shift != null:
		var options = []
		
		for dicespot in skills[axis_][skill_].dicespots:
			var permutation = dicespot.permutation + shift
			
			if Global.dict.permutation.sum.has(permutation):
				options.append(dicespot)
		
		var dicespot = options.pick_random()
		var permutation = dicespot.permutation + shift
		dicespot.set_permutation(permutation)
		multiplication_check(axis_, skill_)


func set_dicespots_sums() -> void:
	for dicespot in dicespots.get_children():
		if dicespot.permutation != null:
			dicespot.set_sum()


func update_uncorrect_skills() -> void:
	for axis in skills:
		for skill in skills[axis]:
			if !skills[axis][skill].correct:
				var node = get_node_by_grid(skills[axis][skill].grid)
				node.bg.visible = true


func get_readymade_skills(style_: String) -> Array:
	var readymades = []
	
	for axis in skills:
		for skill in skills[axis]:
			var data = {}
			data.worktop = self
			data.axis = axis
			data.skill = skill
			readymades.append(data)
	
	match style_:
		"only charged":
			for _i in range(readymades.size()-1, -1, -1):
				var data = readymades[_i]
				
				if !readiness_check(data.axis, data.skill):
					readymades.pop_at(_i)
		"not charged":
			for _i in range(readymades.size()-1, -1, -1):
				var data = readymades[_i]
				
				if readiness_check(data.axis, data.skill):
					readymades.pop_at(_i)
	
	return readymades


func readiness_check(axis_: String, skill_: String) -> bool:
	for dicespot in skills[axis_][skill_].dicespots:
		if !dicespot.active:
			return false
	
	return true


func activate_skill(axis_: String, skill_: String) -> void:
	print(skill_ + " activated")
	var description = Global.dict.skill.title[skill_]
	
	var target = get_target(description)
	
	if target != null:
		apply_effect(target, description)
		
		for dicespot in skills[axis_][skill_].dicespots:
			dicespot.deenergize()
		
		sinner.update_chronicle(skill_)


func get_target(description_: Dictionary) -> Variant:
	var target = null
	var targets = []
	
	match description_.target:
		"random":
			targets = sinner.foes
		"owner":
			targets.append(sinner)
	
	target = targets.pick_random()
	return target


func apply_effect(target_: MarginContainer, description_: Dictionary) -> void:
	var subtarget = null
	var charge = roll_charge(description_)
	
	var sign = Global.dict.sign.variation[description_.variation]
	var shift = sign * charge
	
	if Global.color.indicator.has(description_.subtarget):
		subtarget = target_.indicators.get_indicator_based_on_name(description_.subtarget)
		
		if health_damage_check(description_) and target_.check_active_barrier():
			subtarget = target_.indicators.get_indicator_based_on_name("barrier")
		
		subtarget.update_value(description_.value, shift)
	else:
		match description_.subtarget:
			"turn of events":
				var extra_rounds = floor(charge / 6) + 1
				
				for _i in extra_rounds:
					sinner.team.arena.extra_round.append(sinner)


func roll_charge(description_: Dictionary) -> int:
	var base = description_.base
	var bonus = description_.bonus
	
	if sinner.indicators.ultimate.kit.value > 0:
		var impact = sinner.indicators.ultimate.get_impact()
		
		match sinner.specialization:
			"runologist":
				bonus *= impact
			"berserk":
				base += impact
	
	Global.rng.randomize()
	var charge = base + Global.rng.randi_range(0, bonus)
	return charge


func health_damage_check(description_: Dictionary) -> bool:
	return Global.dict.sign.variation[description_.variation] == -1 and description_.subtarget == "health" and description_.value == "current" 
