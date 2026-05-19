class_name TribunalData
extends Resource


var bygone: GyreData = GyreData.new(self, Bozo.Gyre.BYGONE)
var actual: GyreData = GyreData.new(self, Bozo.Gyre.ACTUAL)
var hereafter: GyreData = GyreData.new(self, Bozo.Gyre.HEREAFTER)


func _init() -> void:
	update_gyre_fol()
	init_fates()

func update_gyre_fol() -> void:
	hereafter.fol = actual
	actual.fol = bygone
	bygone.fol = hereafter

func init_fates() -> void:
	var fates: Array[Bozo.Fate]
	fates.append_array(Catalog.fates)
	fates.shuffle()
	
	for fate in fates:
		add_sinner(fate)
	
	while hereafter.sinners.size() < Catalog.GYRE_HEREAFTER_SINNER_SIZE:
		var fate = fates.pop_back()
		add_sinner(fate)


func add_sinner(fate_: Bozo.Fate) -> void:
	var sinner = SinnerData.new(fate_)
	hereafter.sinners.append(fate_)
	sinner.gyre = hereafter
