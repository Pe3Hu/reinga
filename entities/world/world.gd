class_name World
extends Node


@export var inferno: Inferno
@export var hell: Hell
@export var gate: Gate
@export var sanctuary: Sanctuary
@export var abyss: Abyss
@export var museum: Museum
@export var herald: Herald
@export var transition: Transition


var data = WorldData.new()


func _ready() -> void:
	connect_datas()
	
	#await get_tree().process_frame
	transition.data.next_layer = Bozo.Layer.HERALD
	#transition.apply_layer()
	#inferno.apply_layer()

func connect_datas() -> void:
	sanctuary.data = data.sanctuary
	hell.data = data.hell
	gate.data = data.gate
	abyss.data = data.abyss
	museum.data = data.museum
	transition.data = data.transition

func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()
			KEY_1:
				transition.data.next_layer = Bozo.Layer.HELL
			KEY_2:
				transition.data.next_layer = Bozo.Layer.GATE
			KEY_3:
				transition.data.next_layer = Bozo.Layer.ABYSS
			KEY_Q:
				data.tribunal.print_total_sinners()
