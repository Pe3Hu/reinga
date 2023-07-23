extends MarginContainer


@onready var worktops = $HBox/Worktops
@onready var indicators = $HBox/Indicators

var team = null
var specialization = null
var foes = []
var skills = {}
var chronicle = []
var bans = []
var initiative = 1


func _ready() -> void:
	init_skills()
	init_wortops()
	indicators.label.text = specialization
	indicators.sinner = self
	indicators.ultimate.sinner = self
	indicators.set_bars()


func init_skills() -> void:
	skills.studied = []
	skills.used = []
	skills.studied.append_array(Global.dict.specialization.skill[specialization])


func init_wortops() -> void:
	var n = 2
	
	for _i in n:
		var worktop = Global.scene.worktop.instantiate()
		worktop.sinner = self
		worktops.add_child(worktop)


func fills_dicespots() -> void:
	var dices = team.arena.dices
	var appropriate_dicespots = []
	
	for worktop in worktops.get_children():
		for dicespot in worktop.dicespots.get_children():
			if !dicespot.active and dices.sum_dice.value == dicespot.sum:
				appropriate_dicespots.append(dicespot)
	
	if appropriate_dicespots.is_empty():
		fill_ultimate()
	else:
		var dicespot = appropriate_dicespots.pick_random()
		dicespot.energize()
		
		for dicespot_ in appropriate_dicespots:
			pass
		
		var readymades = dicespot.workstop.get_readymade_skills("only charged")
		
		if !readymades.is_empty():
			choose_ultimate(dicespot, readymades)
			choose_skill(readymades)


func fill_ultimate() -> void:
	for edge in indicators.ultimate.priority:
		if team.arena.dices.values.has(edge):
			indicators.ultimate.fill_cell(edge)
			return


func choose_ultimate(dicespot_: MarginContainer, readymades_: Array) -> void:
	match specialization:
		"runologist":
			var n = 1
			
			if indicators.ultimate.kit.value > n:
				var extra_skills = []
				var extra_readymades = dicespot_.workstop.get_readymade_skills("not charged")
				
				for _i in range(extra_readymades.size()-1, -1, -1):
					var data = extra_readymades[_i]
					
					if bans.has(data.skill):
						extra_readymades.pop_at(_i)
				
				print("runologist ultimate 2")
				choose_skill(extra_readymades)
				
				indicators.ultimate.downgrade_kit(n)


func choose_skill(readymades_: Array) -> void:
	var data = null
	
	match specialization:
		"runologist":
			#print(readymades_)
			for _i in range(readymades_.size()-1, -1, -1):
				if bans.has(readymades_[_i].skill):
					readymades_.pop_at(_i)
			
			#print(readymades_)
			data = readymades_.pick_random()
		"berserk":
			data = readymades_.pick_random()
	
	if data != null:
		data.worktop.activate_skill(data.axis, data.skill)


func check_active_barrier() -> bool:
	var indicator = indicators.get_indicator_based_on_name("barrier")
	
	if indicator != null:
		if indicator.bar.value > 0:
			return true
	
	return false


func knockout() -> void:
	visible = false
	team.arena.initiatives.erase(self)
	
	for foe in foes:
		foe.foes.erase(self)
	
	if !team.check_presence():
		team.arena.end = true
		team.arena.close()


func update_chronicle(skill_: String) -> void:
	chronicle.append(skill_)
	
	if chronicle.size() > 4:
		chronicle.pop_front()
	
	update_bans()


func update_bans() -> void:
	match specialization:
		"runologist":
			bans = []
			var n = 2
			
			for _i in range(chronicle.size() - 1, chronicle.size() - 1 - n, - 1):
				if _i >= 0:
					var skill = chronicle[_i]
					
					if !bans.has(skill):
						bans.append(skill)
					#print(_i, skill)
			
			#print(chronicle)
			#print(bans)
