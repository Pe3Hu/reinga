extends Node


var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()


func get_random_key(dict_: Dictionary):
	if dict_.is_empty():
		push_error("empty dictionary in get_random_key")
		return null
	
	var keys = dict_.keys()
	var total := 0.0
	
	for key in keys:
		total += dict_[key]
	
	if total <= 0:
		return null
	
	var r := rng.randf() * total
	var cumulative := 0.0
	
	for key in keys:
		cumulative += dict_[key]
		if r < cumulative:
			return key
	
	push_error("random selection failed")
	return null

func get_omen_value_based_on_level(omen_: Variant, level_: int = 1) -> int:
	match omen_:
		Bozo.Destiny.GENIUS:
			return formula_a(level_)
		Bozo.Destiny.LEADER:
			return formula_a(level_)
		Bozo.Destiny.EXILE:
			return formula_b(level_)
		Bozo.Destiny.LAYMAN:
			return formula_b(level_)
		Bozo.Family.PARENT:
			return formula_c(level_)
		Bozo.Family.CHILD:
			return formula_d(level_)
	
	return 0

func formula_a(x_: int, factor_: int = 4, offset_: int = 2) -> int:
	return factor_ * (x_ + offset_)

func formula_b(x_: int, offset_: int = 2) -> int:
	return x_ + offset_

func formula_c(x_: int, factor_: int = 4, offset_: int = 1) -> int:
	return factor_ * (x_ + offset_)

func formula_d(x_: int, factor_: int = 6, offset_: int = 1) -> int:
	return factor_ * (x_ + offset_)

func get_focused_text(origin_: String) -> String:
	var result = "[color=black][outline_size=4][outline_color=white]%s" % origin_
	return result

func get_unfocused_text(origin_: String) -> String:
	var result = "[color=white][outline_size=4][outline_color=black]%s" % origin_
	return result

func get_colored_sin(type_: Bozo.Sin) -> String:
	var sin_color = Catalog.sin_to_color[type_].to_html(false)
	var sin_text = Catalog.sin_to_string[type_].capitalize()
	var result = "[color=%s]%s[/color]" % [sin_color, sin_text]
	return result

func get_colored_amber(type_: Bozo.Amber) -> String:
	var amber_color = Catalog.amber_to_color[type_].to_html(false)
	var amber_text = Catalog.amber_to_string[type_].capitalize()
	var result = "[color=%s]%s[/color]" % [amber_color, amber_text]
	return result


func update_colors(node_, overlord_: Bozo.Overlord) -> void:
	var hue = Catalog.overlord_to_hue[overlord_]
	var color_a: Color = Color(Catalog.overlord_to_pallete[0])
	var color_b: Color = Color(Catalog.overlord_to_pallete[1])
	var color_c: Color = Color(Catalog.overlord_to_pallete[2])
	color_a.h += hue
	color_b.h += hue
	color_c.h += hue
	
	if overlord_ == Bozo.Overlord.MARVONE:
		color_a.s = 0
		color_b.s = 0
		color_c.s = 0
	
	node_.material.set_shader_parameter("colorA", color_a)
	node_.material.set_shader_parameter("colorB", color_b)
	node_.material.set_shader_parameter("colorC", color_c)

func get_xalvorr_percents() -> Dictionary:
	var weights = {}
	var rank = Scope.sanctuary.world.throne.xalvorr.rank + Catalog.OVERLORD_MAX_RANK
	
	for modifier in Catalog.overlord_to_modifier[Bozo.Overlord.XALVORR]:
		weights[modifier] = Catalog.modifier_to_rank_to_value[modifier][rank]
	
	return weights

func get_modifier_rank_value(modifier_: Bozo.Modifier, rank_shift_: int = 0) -> int:
	var overlord_type = Catalog.modifier_to_overlord[modifier_]
	var overlord = Scope.sanctuary.world.throne.type_to_overlord[overlord_type]
	var rank = overlord.rank + rank_shift_ + Catalog.OVERLORD_MAX_RANK
	var value = Catalog.modifier_to_rank_to_value[modifier_][rank]
	return value

func get_spectacle_options(blob_: Bozo.Blob) -> Array:
	var spectacle_options: Array
	var origin_factor: int = Scope.spectacle_to_factor[Catalog.spectacles.front()]
	
	for spectacle_type in Scope.spectacle_to_factor:
		if origin_factor == Scope.spectacle_to_factor[spectacle_type]:
			spectacle_options.append(spectacle_type)
		
		match blob_:
			Bozo.Blob.PLUS:
				if origin_factor < Scope.spectacle_to_factor[spectacle_type]:
					origin_factor = Scope.spectacle_to_factor[spectacle_type]
					spectacle_options = [spectacle_type]
			Bozo.Blob.MINUS:
				if origin_factor > Scope.spectacle_to_factor[spectacle_type]:
					origin_factor = Scope.spectacle_to_factor[spectacle_type]
					spectacle_options = [spectacle_type]
	
	return spectacle_options
