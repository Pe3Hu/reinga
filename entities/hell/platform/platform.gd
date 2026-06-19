class_name Platform
extends PanelContainer


var data: PlatformData:
	set(value_):
		data = value_
		connect_datas()
		apply_data_info()


@export var hell: Hell
@export var cells: ColorRect
@export var lightning: MarginContainer

@export var operas: Array[Spectacle]
@export var puppetrys: Array[Spectacle]
@export var ballets: Array[Spectacle]
@export var spectacles: Array[Spectacle]


func connect_datas() -> void:
	for _i in spectacles.size():
		var spectacle = spectacles[_i]
		var spectacle_data = data.spectacles[_i]
		spectacle.data = spectacle_data

func apply_data_info() -> void:
	if !data.fruit_is_changed.is_connected(_on_fruit_is_changed):
		data.fruit_is_changed.connect(_on_fruit_is_changed)
	
	_on_fruit_is_changed()

func _on_is_selected_changed() -> void:
	update_lightning()
	update_immature()

func update_lightning() -> void:
	if !data.jail.table.active_cages.is_empty():
		var cage = data.jail.table.active_cages.back()
		var anchors = Catalog.windrose_to_anchor[cage.contribution.type]
		lightning.size_flags_horizontal = anchors.front()
		lightning.size_flags_vertical = anchors.back()
		lightning.visible = true
	else:
		lightning.visible = false
		#data.previous_fruit = Bozo.Fruit.NONE

func update_immature() -> void:
	if !data.jail.table.active_cages.is_empty():
		var cage = data.jail.table.active_cages.back()
		cage.fruit = Bozo.Fruit.IMMATURE
		_on_fruit_is_changed()

func apply_performances() -> void:
	lightning.visible = false
	data.apply_performances()
	
	update_progressions()
	update_ambers()
	#hell.nightmare.apply_attitude_shifts()

func update_ambers() -> void:
	for amber_data in data.shifted_ambers:
		var tween = create_tween()
		tween.tween_property(amber_data, "value", amber_data.next_value, Gear.spectacle_ambers[Gear.tempo])

func update_progressions() -> void:
	for progression_data in data.shifted_progressions:
		var progression: Progression = hell.nightmare.get_progression(progression_data)
		var _sign = sign(progression_data.next_value)
		var value = abs(progression_data.next_value)
		hell.volcano.burst_splash(progression, value, _sign)

func _on_fruit_is_changed() -> void:
	data.detect_spectalces()
	
	for index in data.index_to_fruit:
		var path = "cell_state_%d" % index
		var fruit = data.index_to_fruit[index]
		
		if !Catalog.fruit_to_state.has(fruit):
			continue
		
		var state = Catalog.fruit_to_state[fruit]
		cells.material.set_shader_parameter(path, state)

func reset() -> void:
	data.reset()
