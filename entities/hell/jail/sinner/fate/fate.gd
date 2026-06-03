class_name Fate
extends Panel


var data: FateData:
	set(value_):
		if data != value_:
			data = value_
			apply_data_info()

@export var sinner: Sinner
@export var label: RichTextLabel


func apply_data_info() -> void:
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
		data.is_selected_changed.connect(_on_is_selected_changed)
	
	_on_type_changed()
	_on_is_selected_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	
	if label:
		unfocus()
		sinner.faction.visible = true

func _on_is_selected_changed() -> void:
	if sinner.cage.contribution:
		#if sinner.cage.contribution.treasury.lock_button:
		sinner.cage.contribution.treasury.lock_button.visible = data.sinner.cage.table.active_cages.size() > 0
	
	if sinner.cage.jail:
		sinner.soul.background.color = Catalog.active_to_color[data.is_selected]
		sinner.cage.jail.data.update_traits()
	
	if data.is_selected:
		focus()
	else:
		unfocus()

func focus() -> void:
	label.text = "[pulse freq=0.66 color=#5b5b5b ease=-2.0]%s" % Catalog.fate_to_string[data.type].capitalize()
	

func unfocus() -> void:
	label.text = Catalog.fate_to_string[data.type].capitalize()
