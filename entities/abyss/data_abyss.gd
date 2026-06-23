class_name AbyssData
extends Resource


var world: WorldData
var tribunal: TribunalData
var table: TableData

var sacrifices: Array[SacrificeData]
var active_sacrifices: Array[SacrificeData]

var sinners: Array[SinnerData]

var counter: int = 0


#region init
func _init(world_: WorldData) -> void:
	world = world_
	table = TableData.new()
	table.abyss = self
	tribunal = world.tribunal
	
	init_sacrifices()

func init_sacrifices() -> void:
	for catena in table.catenas:
		add_sacrifice(catena)

func add_sacrifice(catena_: CatenaData) -> void:
	var sacrifice = SacrificeData.new(self, catena_)
	sacrifices.append(sacrifice)

func init_sinners() -> void:
	sinners.clear()
	var sinner_options = tribunal.get_sinners_for_abyss()
	sinner_options.shuffle()
	
	while sinners.size() < Catalog.GATE_FATE_SIZE and !sinner_options.is_empty():
		var sinner = sinner_options.pop_back()
		sinners.append(sinner)
#endregion

func update_sacrifice_ambers() -> void:
	for sacrifice in sacrifices:
		sacrifice.init_ambers()

func refill_tribunal() -> void:
	var catena = table.active_catenas.back()
	table.reset_all_actives()
	
	for cage in catena.cages:
		var sinner = cage.sinner
		if sinner == null: continue
		tribunal.remove_sinner(sinner)
		sinners.erase(sinner)
		cage.sinner = null
