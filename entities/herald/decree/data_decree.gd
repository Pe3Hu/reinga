class_name DecreeData
extends Resource




var herald: HeraldData
var overlord: OverlordData
var blob: Bozo.Blob

var laws: Array[LawData]

var rank_shift: int
var header_text: String


func _init(herald_: HeraldData, overlord_: OverlordData, blob_: Bozo.Blob) -> void:
	herald = herald_
	overlord = overlord_
	blob = blob_
	
	rank_shift = Catalog.blob_to_shift[blob]
	init_laws()
	updaet_header_text()

func init_laws() -> void:
	match overlord.type:
		Bozo.Overlord.VIRELLO:
			virello_order()
		Bozo.Overlord.XALVORR:
			xalvorr_order()
		Bozo.Overlord.CALTHEX:
			calthex_order()

func virello_order() -> void:
	for modifier in Catalog.overlord_to_modifier[Bozo.Overlord.VIRELLO]:
		add_law(modifier)

func xalvorr_order() -> void:
	for modifier in Catalog.overlord_to_modifier[Bozo.Overlord.XALVORR]:
		add_law(modifier)

func calthex_order() -> void:
	var factor_shift = Catalog.blob_to_shift[blob]
	var options = Helper.get_spectacle_options(blob)
	
	while options.size() < Catalog.CALTHEX_LAW_COUNT:
		var additional_options = Scope.spectacle_to_factor.keys()
		additional_options = additional_options.filter(func (a): return !options.has(a))
		var option = additional_options.pick_random()
		options.append(option)
	
	options.shuffle()
	
	for option in options:
		var modifier = Catalog.spectacle_to_modifier[option]
		Scope.spectacle_to_factor[option] += factor_shift
		add_law(modifier)

func add_law(modifier_: Bozo.Modifier) -> void:
	var law = LawData.new(self, modifier_)
	
	if law.old_value != law.new_value:
		laws.append(law)

func updaet_header_text() -> void:
	header_text = "%s %s" % [Catalog.overlord_to_string[overlord.type].capitalize(), Catalog.blob_to_header[blob]]

func apply_laws() -> void:
	overlord.rank += Catalog.blob_to_shift[blob]
	
	for law in laws:
		law.apply()

func reinit_laws() -> void:
	laws.clear()
	init_laws()
