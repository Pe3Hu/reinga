extends CustomButton


@export var decree: Decree


func _button_pressed() -> void:
	super._button_pressed()
	hide_me()
	decree.data.apply_laws()
	var last_decree = decree.herald.data.release_last_decree()
	
	if last_decree:
		decree.herald.world.transition.data.next_layer = Bozo.Layer.HELL
