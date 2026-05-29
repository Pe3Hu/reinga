class_name World
extends Node


@export var inferno: Inferno
@export var hell: Hell
@export var gate: Gate
@export var sanctuary: Sanctuary


var data = WorldData.new()


func _ready() -> void:
	update_layer()

func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				get_tree().quit()

func reset_visible() -> void:
	hell.visible = false
	gate.visible = false
	sanctuary.visible = false

func update_layer() -> void:
	inferno.apply_layer()
	
	match Scope.layer:
		Bozo.Layer.HELL:
			hell.visible = true
		Bozo.Layer.GATE:
			gate.visible = true
		Bozo.Layer.SANCTUARY:
			sanctuary.visible = true
