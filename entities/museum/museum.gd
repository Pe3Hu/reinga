class_name Museum
extends Control


var data: MuseumData:
	set(value_):
		data = value_
		
		connect_signals()

@export var world: World
@export var gallery: Gallery


func connect_signals() -> void:
	if !data.gallery_is_released.is_connected(_on_gallery_release):
		data.gallery_is_released.connect(_on_gallery_release)

func _on_gallery_release() -> void:
	gallery.data = data.gallerys.pop_back()

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	#%Cages.visible =  true
	data.release_last_gallery()
	#world.inferno.apply_layer()
	#simulate_choice()
