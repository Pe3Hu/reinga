class_name Herald
extends Control


var data: HeraldData:
	set(value_):
		data = value_
		
		connect_signals()
		data.test_decrees()

@export var world: World
@export var decree: Decree
@export var background: ColorRect


func connect_signals() -> void:
	if !data.decree_is_released.is_connected(_on_decree_release):
		data.decree_is_released.connect(_on_decree_release)

func _on_decree_release() -> void:
	decree.data = data.decrees.pop_back()

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
	#world.inferno.apply_layer()
	#unblur_all()
	#data.init_sinners()
	#await get_tree().process_frame
	#update_sinner_datas()
	#Scope.weather = Bozo.Weather.SUN
	#weather_button.updaet_margin_offset()
	#simulate_choice()


func update_background() -> void:
	var hue = Catalog.overlord_to_hue[decree.data.overlord.type]
	var overlord_color = Color.from_hsv(hue, 0.66, 1.0)
	%Background.material.set_shader_parameter("final_color", overlord_color)
	var flag = !Catalog.blob_to_flag[decree.data.blob]
	%Background.material.set_shader_parameter("invert", flag)
