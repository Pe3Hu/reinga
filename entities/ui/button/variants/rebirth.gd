extends CustomButton


@export var ascension: Ascension


func _button_pressed() -> void:
	super._button_pressed()
	
	Scope.is_game = false
	ascension.world.transition.data.next_layer = Bozo.Layer.HELL
