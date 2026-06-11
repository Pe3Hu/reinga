class_name PlatformData
extends TypeData


signal fruit_is_changed

var jail: JailData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.PLATFORM
var spectacles: Array[SpectacleData]
var active_spectacles: Array[SpectacleData]

#var ballets: Array[SpectacleData] 
#var puppetrys: Array[SpectacleData]
#var operas: Array[SpectacleData]

var freshs: Array[CageData]
var ripes: Array[CageData]
var rottens: Array[CageData]
var immatures: Array[CageData]

var index_to_fruit: Dictionary
var shifted_progressions: Array[ProgressionData]
var shifted_ambers: Array[AmberData]


#region init
func _init(jail_: JailData) -> void:
	jail = jail_
	
	init_spectacles()
	init_fruits()
	
	var cage = jail.table.cages[1]
	var fruit = Bozo.Fruit.FRESH
	force_fruit(cage, fruit)
	cage = jail.table.cages[4]
	force_fruit(cage, fruit)
	cage = jail.table.cages[2]
	force_fruit(cage, fruit)
	cage = jail.table.cages[6]
	#force_fruit(cage, Bozo.Fruit.RIPE)

func init_spectacles() -> void:
	for catena in jail.table.catenas:
		add_spectacle(catena)
	
	for catena in jail.table.special_catenas:
		add_spectacle(catena)
	
	#spectacles.sort_custom(func (a, b): return Catalog.spectacles.find(a.type) > Catalog.spectacles.find(b.type))

func add_spectacle(catena_: CatenaData) -> void:
	var spectacle = SpectacleData.new(self, catena_)
	spectacles.append(spectacle)
	
	#match spectacle.type:
		#Bozo.Spectacle.BALLET:
			#ballets.append(spectacle)
		#Bozo.Spectacle.PUPPETRY:
			#puppetrys.append(spectacle)
		#Bozo.Spectacle.OPERA:
			#operas.append(spectacle)

func init_fruits() -> void:
	for index in Catalog.indexs:
		index_to_fruit[index] = Bozo.Fruit.ROTTEN
#endregion

func apply_performances() -> void:
	#jail.hell.nightmare.update_best_and_worst_tribute()
	jail.hell.nightmare.update_best_and_worst_flame()
	jail.hell.nightmare.update_best_and_worst_attitude()
	
	for spectacle in spectacles:
		spectacle.active()
	
	pass
	harvest()

func harvest() -> void:
	index_to_fruit.clear()
	
	#while !rottens.is_empty():
		#var cage = rottens.pop_back()
		#cage.fruit = Bozo.Fruit.NONE
		#index_to_fruit[cage.index] = cage.fruit
	
	while !ripes.is_empty():
		var cage = ripes.pop_back()
		cage.fruit = Bozo.Fruit.ROTTEN
		rottens.append(cage)
		index_to_fruit[cage.index] = cage.fruit
	
	while !freshs.is_empty():
		var cage = freshs.pop_back()
		cage.fruit = Bozo.Fruit.RIPE
		ripes.append(cage)
		index_to_fruit[cage.index] = cage.fruit
	
	while !immatures.is_empty():
		var cage = immatures.pop_back()
		cage.fruit = Bozo.Fruit.FRESH
		freshs.append(cage)
		index_to_fruit[cage.index] = cage.fruit
	
	emit_signal("fruit_is_changed")

func undo_immature_cage(cage_: CageData) -> void:
	if Scope.phase != Bozo.Phase.INVESTMENT:
		cage_.fruit = cage_.previous_fruit#Bozo.Fruit.NONE
		cage_.previous_fruit = Bozo.Fruit.NONE
		index_to_fruit[cage_.index] = cage_.fruit
		immatures.erase(cage_)
		emit_signal("fruit_is_changed")

func detect_spectalces() -> void:
	for spectacle in spectacles:
		spectacle.update_is_selected()

func reset() -> void:
	active_spectacles.clear()
	
	for cage in jail.table.cages:
		cage.previous_fruit = Bozo.Fruit.NONE
	
	for progression in shifted_progressions:
		progression.next_value = 0

func force_fruit(cage_: CageData, fruit_: Bozo.Fruit) -> void:
	cage_.fruit = fruit_
	index_to_fruit[cage_.index] = cage_.fruit
	
	match fruit_:
		Bozo.Fruit.IMMATURE:
			immatures.append(cage_)
		Bozo.Fruit.FRESH:
			freshs.append(cage_)
		Bozo.Fruit.RIPE:
			ripes.append(cage_)
		Bozo.Fruit.ROTTEN:
			rottens.append(cage_)
	
	emit_signal("fruit_is_changed")
