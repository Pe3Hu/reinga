class_name CageData
extends Resource


var table: TableData
var sinner: SinnerData:
	set(value_):
		sinner = value_
		sinner.cage = self

var col: CatenaData
var row: CatenaData
var contribution: ContributionData

var neighbours: Array[CageData]
var coord: Vector2i
var index: int

var tooltip: Bozo.Tooltip = Bozo.Tooltip.CAGE
var destiny: Bozo.Destiny

var status: Bozo.Cage = Bozo.Cage.NONE:
	set(value_):
		status = value_
		
		if sinner:
			sinner.soul.reset_blur()
			var traits = Catalog.cage_to_traits[status]
			
			for _trait in traits:
				sinner.soul.select_trait(_trait)

var fruit: Bozo.Fruit = Bozo.Fruit.ROTTEN:
	set(value_):
		if fruit != value_:
			update_previous_fruit()
			fruit = value_
			
			match fruit:
				Bozo.Fruit.FRESH:
					col.spectacle.cages.append(self)
					row.spectacle.cages.append(self)
				Bozo.Fruit.NONE:
					col.spectacle.cages.erase(self)
					row.spectacle.cages.erase(self)
			
			col.spectacle.platfrom.index_to_fruit[index] = fruit

var previous_fruit: Bozo.Fruit = Bozo.Fruit.NONE:
	set(value_):
		previous_fruit = value_
		pass


func _init(table_: TableData, coord_: Vector2i):
	table = table_
	coord = coord_ 
	index = table.cages.size()

#region omen
func check_destiny(destiny_: Bozo.Destiny) -> bool:
	if destiny_ == Bozo.Destiny.GENIUS:
		return table.jail.platform.freshs.has(self)
		#return table.genius_coord == coord
	
	return destiny == destiny_

func get_destiny_status(destiny_: Bozo.Destiny) -> Bozo.Status:
	var flag = check_destiny(destiny_)
	return Catalog.bool_to_status[flag]

func get_family_status(family_: Bozo.Family) -> Bozo.Status:
	var successes: int = 0
	
	for neighbour in neighbours:
		match family_:
			Bozo.Family.PARENT:
				if neighbour.sinner.fate.faction.type == sinner.fate.faction.type:
					successes += 1
			Bozo.Family.CHILD:
				if neighbour.sinner.fate.type == sinner.fate.type:
					successes += 1
	
	var flag: bool = successes >= Catalog.family_to_success[family_]
	return Catalog.bool_to_status[flag]
#endregion

func update_previous_fruit() -> void:
	previous_fruit = fruit
