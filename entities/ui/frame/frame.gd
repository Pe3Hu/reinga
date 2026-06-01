@tool
class_name Frame
extends NinePatchRect


@export var type: Bozo.Frame:
	set(value_):
		type = value_
		update_region_size()
		update_patch_margin()
		update_texture()

@export var subtype: String = "":
	set(value_):
		subtype = value_
		update_texture()


func update_region_size() -> void:
	var l = Catalog.frame_to_region[type]
	region_rect = Rect2(0, 0, l, l)

func update_patch_margin() -> void:
	var l = Catalog.frame_to_patch[type]
	patch_margin_bottom = l
	patch_margin_top = l
	patch_margin_left = l
	patch_margin_right = l
	
	match type:
		Bozo.Frame.MARKET:
			patch_margin_bottom -= 6
			patch_margin_top -= 6

func update_texture() -> void:
	var a = Catalog.frame_to_string[type]
	texture = load("res://entities/ui/frame/images/%s.png" % a)
	
	if subtype != "":
		var b = subtype
		texture = load("res://entities/ui/frame/images/%s/%s %s.png" % [a, a, b])
