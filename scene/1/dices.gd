extends VBoxContainer


var dice_count = 2


func _ready() -> void:
	for _i in dice_count:
		add_dice()
	
	roll_dices()


func add_dice() -> void:
	var dice = Global.scene.dice.instantiate()
	add_child(dice)


func roll_dices() -> void:
	for dice in get_children():
		dice.roll()
