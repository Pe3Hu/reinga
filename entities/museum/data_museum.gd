class_name MuseumData
extends Resource


var world: WorldData
var tribunal: TribunalData
var table: TableData

var sacrifices: Array[SacrificeData]
var active_sacrifices: Array[SacrificeData]

var sinners: Array[SinnerData]


#region init
func _init(world_: WorldData) -> void:
	world = world_
	table = TableData.new()
	table.museum = self
	tribunal = world.tribunal
	
	init_sacrifices()

func init_sacrifices() -> void:
	for catena in table.catenas:
		add_sacrifice(catena)

func add_sacrifice(catena_: CatenaData) -> void:
	pass
	#var sacrifice = SacrificeData.new(self, catena_)
	#sacrifices.append(sacrifice)

func init_sinners() -> void:
	sinners.clear()
	var sinner_options = tribunal.get_all_sinners()
	sinner_options.shuffle()
	
	while sinners.size() < Catalog.GATE_FATE_SIZE:
		var sinner = sinner_options.pop_back()
		sinners.append(sinner)
#endregion

func update_sacrifice_ambers() -> void:
	for sacrifice in sacrifices:
		sacrifice.init_ambers()
