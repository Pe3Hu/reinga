@tool
class_name TokenFaction
extends Token


@export var smoke: ColorRect


func apply_data_info() -> void:
	super.apply_data_info()
	
	if !data.type_changed.is_connected(_on_type_changed):
		#data.type_changed.disconnect(_on_type_changed)
	
		data.type_changed.connect(_on_type_changed)
		data.association_changed.connect(_on_association_changed)
		texture_rect.material = ShaderMaterial.new()
		texture_rect.material.shader = load("uid://dpwosepildkhk")
		smoke.material = ShaderMaterial.new()
		smoke.material.shader = load("uid://cpdpc4c7cty0b")
		smoke.material.set_shader_parameter("instance_seed", randf() * 1000.0)
	
	_on_type_changed()

func _on_type_changed() -> void:
	if data.type == 0: return
	update_materials()

func update_materials() -> void:
	texture_rect.texture = load("res://entities/ui/token/faction/images/%s.png" % Catalog.faction_to_string[data.type])
	var color = Catalog.faction_to_color[data.type]
	
	if Catalog.special_fates.has(data.fate.type):
		color = Catalog.relationship_to_color[data.fate.relationship]
	
	texture_rect.material.set_shader_parameter("top_color", color)
	smoke.visible = data.association == Bozo.Association.BROTHERHOOD
	
	if data.association == Bozo.Association.NONE:
		color.a = 0.1
		var direction = Catalog.faction_to_direction[data.type]
		texture_rect.material.set_shader_parameter("direction_mode", direction)
	else:
		var fire_color = color
		
		if Catalog.special_fates.has(data.fate.type):
			fire_color = Catalog.relationship_to_color[data.fate.relationship]
		
		smoke.material.set_shader_parameter("fire_color", fire_color)
	
	texture_rect.material.set_shader_parameter("bottom_color", color)
	visible = true

func _on_association_changed() -> void:
	update_materials()
