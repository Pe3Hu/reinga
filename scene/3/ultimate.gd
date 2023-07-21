extends MarginContainer


@onready var cells = $Cells


func _ready() -> void:
	for edge in Global.arr.edge:
		var cell = Global.scene.cell.instantiate()
		cells.add_child(cell)
		cell.name = str(edge)


func fill_cell(value_: int) -> void:
	for cell in cells.get_children():
		if cell.name == str(value_):
			cell.shift_value(1)
