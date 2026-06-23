extends CustomButton


@export var decree: Decree


func _button_pressed() -> void:
	super._button_pressed()
	hide_me()
	decree.data.apply_laws()
	
	var last_decree = decree.herald.data.release_last_decree()
	
	if last_decree:
		var world = decree.herald.world
		if world.museum.data.gallerys.is_empty():
			world.transition.data.next_layer = Bozo.Layer.HELL
		else:
			world.transition.data.next_layer = Bozo.Layer.MUSEUM
