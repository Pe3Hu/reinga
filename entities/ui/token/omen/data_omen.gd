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


#region init
func _init(type_: Bozo.Omen) -> void:
	type = type_

func roll_token() -> void:
	var value = Helper.get_omen_value_based_on_level(subtype)
	var sin_type = Catalog.sins.pick_random()
	token = SinData.new(sin_type, value)
#endregion

func update_status(cage_: CageData = null) -> void:
	var cage = cage_ if cage_ else doom.soul.sinner.cage
	if cage == null:
		push_warning("OmenData.update_status: sinner has no cage")
		return
	
	match type:
		Bozo.Omen.DESTINY:
			status = cage.get_destiny_status(subtype)
		Bozo.Omen.FAMILY:
			status = cage.get_family_status(subtype)
	
	if status == Bozo.Status.ON and cage.table.jail:
		cage.table.jail.hell.treasury.omens.append(self)
