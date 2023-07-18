extends MarginContainer


@onready var sinners = $Sinners

var arena = null
var side = null


func set_side(side_: String) -> void:
	side = side_
	
	match side:
		"Left":
			$BG.color = Color.SKY_BLUE
		"Right":
			$BG.color = Color.INDIAN_RED
