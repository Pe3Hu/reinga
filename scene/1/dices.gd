extends VBoxContainer


@onready var sum_dice =  $"../Sum"

var dice_count = 2
var values = []


func _ready() -> void:
	for _i in dice_count:
		add_dice()


func add_dice() -> void:
	var dice = Global.scene.dice.instantiate()
	add_child(dice)
	dice.get_node("BG").visible = true
	dice.dices = self


func roll_dices() -> void:
	values = []
	sum_dice.value = 0
	
	for dice in get_children():
		dice.roll()
	
	sum_dice.label.text = str(sum_dice.value)
