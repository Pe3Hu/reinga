extends CustomButton


@export var abyss: Abyss


func update_visible() -> void:
	super.update_visible()
	visible = abyss.data.table.active_cages.size() > 0


func _button_pressed() -> void:
	super._button_pressed()
	hide_me()
	#abyss.data.refill_tribunal()
	#Scope.phase = Bozo.Phase.ENDOWMENT
	abyss.world.transition.data.next_layer = Bozo.Layer.HELL
