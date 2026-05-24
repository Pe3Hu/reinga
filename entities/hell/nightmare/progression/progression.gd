@tool
class_name Progression
extends HBoxContainer


@export var type: Bozo.Progression
@export var current_label: Label
@export var limit_label: Label

@export var current_value: int:
	set(value_):
		current_value = value_
		current_label.text = str(current_value)
		update()
@export var limit_value: int = 10:
	set(value_):
		limit_value = value_
		limit_label.text = str(limit_value)


func update() -> void:
	var node = get_parent().get_parent()
	
	match type:
		Bozo.Progression.ACTIVITY:
			if current_value < limit_value and node.type != Bozo.Half.LESS:
				node.type = Bozo.Half.LESS
			elif current_value < limit_value * 2 and node.type != Bozo.Half.MORE:
				node.type = Bozo.Half.MORE
			elif current_value == limit_value * 2 and node.type != Bozo.Half.DOUBLE:
				node.type = Bozo.Half.DOUBLE
		Bozo.Progression.FLAME:
			if current_value >= limit_value:
				current_value -= limit_value
				node.level += 1
