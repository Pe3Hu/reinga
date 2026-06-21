extends CustomButton


@export var gallery: Gallery


func update_visible() -> void:
	super.update_visible()
	visible = gallery.data != null and gallery.data.active_exhibits.size() > 0

func _end_museum_session() -> void:
	gallery.data = null
	gallery.stop_simulate_forge()
	gallery.museum.world.transition.data.next_layer = Bozo.Layer.HELL

func _button_pressed() -> void:
	super._button_pressed()
	if gallery.data == null or !gallery.data.is_prepared:
		_end_museum_session()
		return
	if gallery.data.active_exhibits.is_empty():
		return
	hide_me()
	gallery.data.fuse_active_exhibit()
	
	var last_gallery = gallery.museum.data.release_last_gallery()
	
	if last_gallery:
		_end_museum_session()
