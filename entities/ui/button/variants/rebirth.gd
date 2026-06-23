extends CustomButton


@export var exodus: Exodus


func _button_pressed() -> void:
	super._button_pressed()
	
	Cycle.stop()
	Scope.is_game = false
	exodus.world.transition.data.next_layer = Bozo.Layer.MENU
