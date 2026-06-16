class_name DecreeData
extends Resource



var herald: HeraldData
var overlord: Bozo.Overlord
var blob: Bozo.Blob

var laws: Array[LawData]



func _init(herald_: HeraldData, overlord_: Bozo.Overlord, blob_: Bozo.Blob) -> void:
	herald = herald_
	overlord = overlord_
	blob = blob_
	
	init_laws()

func init_laws() -> void:
	match overlord:
		Bozo.Overlord.VIRELLO:
			virello_order()

func virello_order() -> void:
	for modifier in Catalog.overlord_to_modifier[Bozo.Overlor.VIRELLO]:
		add_law(modifier)

func add_law(modifier_: Bozo.Modifier) -> void:
	var law = LawData.new(self, modifier_)
	laws.append(law)

func apply() -> void:
	pass
