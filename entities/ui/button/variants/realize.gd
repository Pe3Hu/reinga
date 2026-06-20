extends CustomButton


@export var gallery: Gallery


func update_visible() -> void:
	super.update_visible()
	visible = gallery.data.active_exhibits.size() > 0

func _button_pressed() -> void:
	super._button_pressed()
	hide_me()
	gallery.data.fuse_active_exhibit()
	
	var last_gallery = gallery.museum.data.release_last_gallery()
	
	if last_gallery:
		gallery.museum.world.transition.data.next_layer = Bozo.Layer.HELL
