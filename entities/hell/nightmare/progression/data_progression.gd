class_name ProgressionData
extends Resource


signal current_value_changed(new_value)
signal limit_value_changed(new_value)

var boss: Resource
var type: Bozo.Progression

var current_value: int:
	set(value_):
		current_value = value_
		update()
		emit_signal("current_value_changed")
var limit_value: int = 0:
	set(value_):
		limit_value = value_
		emit_signal("limit_value_changed")
var next_value: int


func _init(boss_: Resource) -> void:
	boss = boss_

func update() -> void:
	match type:
		Bozo.Progression.TRIBUTE:
			if current_value < limit_value:
				boss.type = Bozo.Half.LESS
			elif current_value < limit_value * 2:
				boss.type = Bozo.Half.MORE
			elif current_value == limit_value * 2:
				boss.type = Bozo.Half.DOUBLE
		Bozo.Progression.FLAME:
			if current_value >= limit_value:
				current_value -= limit_value
				boss.level += 1
			if current_value < 0:
				if boss.level > 1:
					boss.level -= 1
					current_value += limit_value
				else:
					current_value = 0
