extends MarginContainer


@onready var bars = $VBox/Bars
@onready var label = $VBox/Label

var sinner = null


func _ready() -> void:
	set_bars()


func set_bars() -> void:
	for bar in bars.get_children():
		bar.type = bar.name.to_lower()
		bar.update_color()
