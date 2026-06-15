extends CustomButton


@export var museum: Museum


func update_visible() -> void:
	super.update_visible()
	visible = museum.data.active_exhibits.size() > 0

func _button_pressed() -> void:
	super._button_pressed()
	hide_me()
	museum.data.fuse_active_exhibit()
	museum.world.transition.data.next_layer = Bozo.Layer.HELL
