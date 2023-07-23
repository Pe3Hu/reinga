extends MarginContainer

@onready var bar = $ProgressBar
@onready var indicators = $".."

var type = null


func update_color() -> void:
	var keys = ["fill", "background"]
	
	match type:
		"health":
			bar.value = bar.max_value
		"endurance":
			bar.value = 0
		"barrier":
			bar.value = bar.max_value
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.indicator[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)
		#var style_box = bar.get(path)
		#var color = Global.color.indicator[type.to_lower()][key]
		#style_box.bg_color = color


func update_value(value_: String, shift_: int) -> void:
	match value_:
		"current":
			bar.value += shift_
			print(type, bar.value)
			if bar.value < bar.min_value:
				if type == "barrier":
					var indicator = indicators.get_indicator_based_on_name("health")
					indicator.update_value("current", bar.value - bar.min_value)
				
				bar.value = bar.min_value
		"maximum":
			bar.max_value += shift_
