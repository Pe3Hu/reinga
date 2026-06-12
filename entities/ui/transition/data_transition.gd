class_name TransitionData
extends Resource


signal next_layer_changed

var world: WorldData
var current_layer: Bozo.Layer
var next_layer: Bozo.Layer = Bozo.Layer.NONE:
	set(value_):
		if value_ != current_layer:
			if value_ != Bozo.Layer.NONE:
				emit_signal("next_layer_changed")
		
		
		next_layer = value_


func _init(world_: WorldData) -> void:
	world = world_
	current_layer = Bozo.Layer.HELL
	next_layer = Bozo.Layer.HELL

func reset() -> void:
	Scope.layer = next_layer
	current_layer = next_layer

	match current_layer:
		Bozo.Layer.GATE: 
			world.gate.table.reset_all_actives()
		Bozo.Layer.HELL: 
			world.hell.jail.table.reset_all_actives()
			Scope.next_phase()
		Bozo.Layer.SANCTUARY:
			pass 
