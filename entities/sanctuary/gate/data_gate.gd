class_name GateData
extends Resource


var world: WorldData
var tribunal: TribunalData
var table: TableData

var sinners: Array[SinnerData]
var fate_options: Array[Bozo.Fate]
var fate_to_count: Dictionary

var is_open: bool = true#false


#region init
func _init(world_: WorldData) -> void:
	world = world_
	table = TableData.new()
	table.gate = self
	tribunal = world.tribunal
	
	init_fates()

func init_fates() -> void:
	sinners.clear()
	fate_options.clear()
	fate_options.append_array(Catalog.fates)
	fate_options.shuffle()
	
	while sinners.size() < Catalog.GATE_FATE_SIZE:
		var fate = fate_options.pick_random()
		add_sinner(fate)

func add_sinner(fate_: Bozo.Fate) -> void:
	var sinner = SinnerData.new(fate_)
	sinners.append(sinner)
	sinner.gate = self
	
	if !fate_to_count.has(fate_):
		fate_to_count[fate_] = 0
	
	fate_to_count[fate_] += 1
	
	if fate_to_count[fate_] == Catalog.GATE_FATE_MAX:
		fate_to_count.erase(fate_)
		fate_options.erase(fate_)
#endregion

func refill_tribunal() -> void:
	var catena = table.active_catenas.back()
	
	for cage in catena.cages:
		print(Catalog.fate_to_string[cage.sinner.fate.type])
		tribunal.foreground_sinners.append(cage.sinner)
	
	world.tribunal.print_total_sinners()
