class_name TooltipData
extends Resource

@export var type: Bozo.Tooltip:
	set(value_):
		type = value_
		header = Catalog.tooltip_to_string[type]
@export var header: String:
	set(value_):
		print(value_)
		header = Helper.get_focused_text(value_.capitalize())
@export var descritipion: String:
	set(value_):
		var text = value_
		
		#if text.contains(" %s, "):
		#	text = text.replace("%s", ",")
		
		if text.contains("%s"):
			text = text.replace("%s", "")
		
		#if text.contains(" ,"):
		#	text = text.replace(" ,", ",")
		
		descritipion = Helper.get_unfocused_text(text)
