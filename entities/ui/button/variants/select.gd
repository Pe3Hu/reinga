extends CustomButton


@export var gate: Gate


func update_visible() -> void:
	super.update_visible()
	visible = gate.data.table.active_cages.size() > 0


func _button_pressed() -> void:
	super._button_pressed()
	hide_me()
	gate.data.refill_tribunal()
	#Scope.phase = Bozo.Phase.ENDOWMENT
	gate.world.transition.data.next_layer = Bozo.Layer.HELL
