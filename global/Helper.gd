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
