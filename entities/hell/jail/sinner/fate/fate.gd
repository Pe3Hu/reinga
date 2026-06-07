class_name Fate
extends Panel


var data: FateData:
	set(value_):
		if data != value_:
			data = value_
			data.is_selected = false
			apply_data_info()

@export var sinner: Sinner
@export var label: RichTextLabel


func apply_data_info() -> void:
	if !data.type_changed.is_connected(_on_type_changed):
		data.type_changed.connect(_on_type_changed)
		data.is_selected_changed.connect(_on_is_selected_changed)
		data.association_changed.connect(_on_association_changed)
	
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
		sinner.cage.contribution.treasury.lock_button.update_visible()
	
	if sinner.cage.jail:
		sinner.soul.background.color = Catalog.active_to_color[data.is_selected]
		sinner.cage.jail.data.update_traits()
	
	if data.is_selected:
		focus()
	else:
		unfocus()
	
	apply_association()

func focus() -> void:
	#unfocus()
	#label.text = "[pulse freq=0.66 color=#5b5b5b ease=-2.0]%s" % label.text
	label.text = "[outline_size=4][outline_color=white][color=black]%s" % Catalog.fate_to_string[data.type].capitalize()

func unfocus() -> void:
	label.text = "[outline_size=4][outline_color=black]%s" % Catalog.fate_to_string[data.type].capitalize()

func _on_association_changed() -> void:
	apply_association()

func apply_association() -> void:
	if data.association == Bozo.Association.GUILD:
		if data.type == Bozo.Fate.TRAITOR: return
		#apply_glitch()
		label.text = "[tornado radius=4 freq=1.6]%s" % label.text

func apply_glitch() -> void:
	for effect in label.get_effects():
		if effect is RichTextGlitch:
			effect.reset_cache()
	
	label.text = "[glitch]"+label.text
