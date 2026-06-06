class_name DoomData
extends Resource


var soul: SoulData
var omens: Array[OmenData]
var destiny: OmenData 
var family: OmenData


func _init(soul_: SoulData) -> void:
	soul = soul_
	
	roll_omens()

func roll_omens() -> void:
	var options: Array[Bozo.Omen]
	options.append_array(Catalog.omens)
	options.shuffle()
	
	while !options.is_empty():
		var omen_type = options.pop_back()
		var omen = OmenData.new(self, omen_type)
		omens.append(omen)
		set(Catalog.omen_to_string[omen_type], omen)
