class_name TribunalData
extends Resource


var world: WorldData
var bygone: GyreData = GyreData.new(self, Bozo.Gyre.BYGONE)
var actual: GyreData = GyreData.new(self, Bozo.Gyre.ACTUAL)
var hereafter: GyreData = GyreData.new(self, Bozo.Gyre.HEREAFTER)


func _init(world_: WorldData) -> void:
	world = world_
	update_gyre_fol()
	update_gyre_ere()
	init_fates()

func update_gyre_fol() -> void:
	hereafter.fol = actual
	actual.fol = bygone
	bygone.fol = hereafter

func update_gyre_ere() -> void:
	hereafter.ere = bygone
	actual.ere = hereafter
	bygone.ere = actual

func init_fates() -> void:
	var fates: Array[Bozo.Fate]
	fates.append_array(Catalog.fates)
	fates.shuffle()
	
	for fate in fates:
		add_sinner(fate)
	
	while hereafter.sinners.size() < Catalog.GYRE_HEREAFTER_SINNER_SIZE and !fates.is_empty():
		var fate = fates.pop_back()
		add_sinner(fate)

func add_sinner(fate_: Bozo.Fate) -> void:
	var sinner = SinnerData.new(fate_)
	hereafter.sinners.append(sinner)
	sinner.gyre = hereafter

func refill_actual() -> void:
	if hereafter.sinners.is_empty():
		hereafter.ere.clear()
	
	while actual.sinners.size() < Catalog.GYRE_ACTUAL_SINNER_SIZE:
		hereafter.transfer_sinner()
