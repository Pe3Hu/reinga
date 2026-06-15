class_name OmenData
extends TypeData


signal subtype_changed
signal status_changed


var doom: DoomData
var exhibit: ExhibitData
var token: SinData
var tooltip: Bozo.Tooltip = Bozo.Tooltip.OMEN
var type: Bozo.Omen:
	set(value_):
		if value_ != type:
			type = value_
			emit_signal("type_changed")
var subtype: Variant:
	set(value_):
		if value_ != subtype:
			subtype = value_
			roll_token()
			emit_signal("subtype_changed")
var status: Bozo.Status = Bozo.Status.ON:
	set(value_):
		if value_ != status:
			status = value_
			emit_signal("status_changed")


func _init(type_: Bozo.Omen) -> void:
	type = type_

func roll_token() -> void:
	var value = Helper.get_omen_value_based_on_level(subtype)
	var sin_type = Catalog.sins.pick_random()
	token = SinData.new(sin_type, value)

func update_status() -> void:
	match type:
		Bozo.Omen.DESTINY:
			status = doom.soul.sinner.cage.get_destiny_status(subtype)
		Bozo.Omen.FAMILY:
			status = doom.soul.sinner.cage.get_family_status(subtype)
	
	if status == Bozo.Status.ON:
		doom.soul.sinner.cage.table.jail.hell.treasury.omens.append(self)
		
