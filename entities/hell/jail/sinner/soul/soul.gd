class_name Soul
extends MarginContainer


var data: SoulData:
	set(value_):
		data = value_
		if data != null:
			connect_datas()

@export var sinner: Sinner
@export var background: ColorRect
@export var doom: Doom
@export var fear: Trait
@export var horror: Trait
@export var guilt: Trait
@export var repose: Trait

@export var traits: Array[Trait]


#region init
func connect_datas() -> void:
	if data == null:
		return
	fear.data = data.fear
	horror.data = data.horror
	guilt.data = data.guilt
	repose.data = data.repose
	doom.data = data.doom
#endregion

func show_all() -> void:
	doom.apply_select_visiblity()
	
	for _trait in traits:
		if _trait.data:
			_trait.visible = true
			_trait.data.is_selected = true
