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
		Bozo.Overlord.KHARZEN:
			fate_order()
		Bozo.Overlord.SIREXIL:
			fate_order()

func virello_order() -> void:
	for modifier in Catalog.overlord_to_modifier[Bozo.Overlord.VIRELLO]:
		add_law(modifier)

func xalvorr_order() -> void:
	for modifier in Catalog.overlord_to_modifier[Bozo.Overlord.XALVORR]:
		add_law(modifier)

func calthex_order() -> void:
	var lagging = Helper.get_spectacle_options(blob)
	var options = lagging.duplicate()
	
	while options.size() < Catalog.CALTHEX_LAW_COUNT:
		var additional_options = Scope.spectacle_to_factor.keys()
		additional_options = additional_options.filter(func (a): return !options.has(a))
		if additional_options.is_empty():
			break
		options.append(additional_options.pick_random())
	
	if options.size() > Catalog.CALTHEX_LAW_COUNT:
		options.shuffle()
		options.resize(Catalog.CALTHEX_LAW_COUNT)
	
	options.shuffle()
	
	for option in options:
		add_law(Catalog.spectacle_to_modifier[option])

func fate_order() -> void:
	var fate_type = Catalog.overlord_to_blob_to_fate[overlord.type][blob]
	var modifier: Bozo.Modifier
	
	match overlord.type:
		Bozo.Overlord.KHARZEN:
			modifier = Bozo.Modifier.TRUST
		Bozo.Overlord.SIREXIL:
			modifier = Bozo.Modifier.HOPE
	
	add_law(modifier, fate_type)

func add_law(modifier_: Bozo.Modifier, fate_: Bozo.Fate = Bozo.Fate.NONE) -> void:
	var law = LawData.new(self, modifier_, fate_)
	
	if law.old_value != law.new_value:
		laws.append(law)
	
	if fate_ != Bozo.Fate.NONE:
		laws.append(law)

func updaet_header_text() -> void:
	header_text = "%s %s" % [Catalog.overlord_to_string[overlord.type].capitalize(), Catalog.blob_to_header[blob]]

func apply_laws() -> void:
	overlord.rank += Catalog.blob_to_shift[blob]
	
	match overlord.type:
		Bozo.Overlord.CALTHEX:
			for spectalce in Scope.spectacle_to_factor:
				Scope.spectacle_to_factor[spectalce] -= Catalog.blob_to_shift[blob]
	
	for law in laws:
		law.apply()
	
	
	herald.reinit_same_decrees(overlord.type)

func reinit_laws() -> void:
	laws.clear()
	init_laws()
