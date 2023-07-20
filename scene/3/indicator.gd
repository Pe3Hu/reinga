extends MarginContainer

@onready var bar = $ProgressBar

var type = null


func update_color() -> void:
	var keys = ["fill", "background"]
	
	match type:
		"health":
			bar.value = bar.max_value
		"endurance":
			bar.value = 0
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.indicator[type][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)
		#var style_box = bar.get(path)
		#var color = Global.color.indicator[type.to_lower()][key]
		#style_box.bg_color = color
