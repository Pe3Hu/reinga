@tool
class_name Blob
extends TextureRect


@export var type: Bozo.Blob:
	set(value_):
		type = value_
		texture = load("res://entities/ui/bowl/blob/images/%s.png" % Catalog.blob_to_string[type])

@export var trial: Bozo.Trial = Bozo.Trial.BATTLE:
	set(value_):
		trial = value_
		if trial == 0 or trial == null: return
		is_active = is_active

@export var is_active: bool = false:
	set(value_):
		is_active = value_
		
		if is_active and trial != 0:
			modulate = Catalog.trial_to_color[trial]
			return
		
		modulate = Catalog.blob_default_color
