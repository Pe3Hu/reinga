class_name SpectacleData
extends TypeData


signal is_selected_changed

var platfrom: PlatformData
var catena: CatenaData
var type: Bozo.Spectacle:
	set(value_):
		type = value_

var cages: Array[CageData]

var is_selected: bool = false:
	set(value_):
		if value_ != is_selected:
			is_selected = value_
			
			if is_selected:
				platfrom.active_spectacles.append(self)
			else:
				platfrom.active_spectacles.erase(self)
			
			emit_signal("is_selected_changed")


func _init(platfrom_: PlatformData, catena_: CatenaData) -> void:
	platfrom = platfrom_
	catena = catena_
	catena.spectacle = self
	type = Catalog.catena_to_spectacle[catena.type]

func update_is_selected() -> void:
	for cage in catena.cages:
		if cage.fruit == Bozo.Fruit.ROTTEN:
			is_selected = false
			return
	
	is_selected = true

func active() -> void:
	if !is_selected: return
	is_selected = false
	
	match type:
		Bozo.Spectacle.BALLET:
			apply_amber_shift()
		Bozo.Spectacle.PUPPETRY:
			apply_attitude_shift()
		Bozo.Spectacle.OPERA:
			apply_attitude_flame()

func apply_amber_shift() -> void:
	var shift = Scope.amber_shift
	var amber = platfrom.jail.hell.bank.type_to_amber[Bozo.Amber.INDOLENCE]
	amber.next_value = amber.value + shift
	platfrom.shifted_ambers.append(amber)

func apply_attitude_shift() -> void:
	var shift = Scope.attitude_shift
	var attitude = platfrom.jail.hell.nightmare.best_attitude
	#var text = Catalog.trial_to_string[attitude.trial.type]
	attitude.shifts.append(shift)
	#attitude.progression.next_value = shift
	#platfrom.shifted_progressions.append(attitude.progression)
	#print(["attitude", text, shift])


func apply_attitude_flame() -> void:
	var shift = Scope.flame_shift
	var flame = platfrom.jail.hell.nightmare.worst_flame
	flame.progression.next_value = -shift
	platfrom.shifted_progressions.append(flame.progression)
