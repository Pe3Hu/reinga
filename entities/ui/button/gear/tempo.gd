@tool
class_name TempoButton
extends TextureButton



@export var gear: GearTab
@export var type: Bozo.Tempo:
	set(value_):
		type = value_
		update_icons()

@export var status: Bozo.Status = Bozo.Status.OFF:
	set(value_):
		if value_ == Bozo.Status.ON and gear:
			gear.off_buttons(self)
		
		status = value_
		update_pressed()

func _ready() -> void:
	pressed.connect(_button_pressed)

func _button_pressed() -> void:
	status = Bozo.Status.ON
	Gear.tempo = Catalog.tempo_to_int[type]

func switch_status() -> void:
	status = Catalog.status_to_next[status]

func update_icons() -> void:
	var type_str = Catalog.tempo_to_string[type]
	texture_normal = load("res://entities/ui/button/gear/images/%s off.png" % type_str)
	#texture_pressed = load("res://entities/ui/button/gear/images/%s on.png" % type_str)
	texture_disabled = load("res://entities/ui/button/gear/images/%s on.png" % type_str)

func update_pressed() -> void:
	disabled = Bozo.Status.ON == status
	
	if !disabled:
		button_pressed = false
