extends Control
class_name Catena


var data: CatenaData:
	set(value_):
		data = value_
		apply_data_info()

var jail: Jail
var gate: Gate
var abyss: Abyss


func apply_data_info() -> void:
	if !data.is_selected_changed.is_connected(_on_is_selected_changed):
		data.is_selected_changed.connect(_on_is_selected_changed)
		data.z_index_changed.connect(_on_z_index_changed)
		reset_lightning()

func reset_lightning() -> void:
	%Lightning.material = ShaderMaterial.new()
	%Lightning.material.shader = load("uid://xdi5lmvmean2")
	%Lightning.material.set_shader_parameter("seed", randf() * 100.0)
	
	if data.coord.y == 0:
		position.x = (Catalog.CAGE_SIZE.x + Catalog.CAGE_OFFSET.x) * (data.coord.x - 1)
		%Lightning.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.JAIL_SIZE.y)
	else:
		position.y = (Catalog.CAGE_SIZE.y + Catalog.CAGE_OFFSET.y) * data.coord.y  
		%Lightning.size = Vector2(Catalog.CAGE_SIZE.y, Catalog.JAIL_SIZE.x)
		%Lightning.rotation = PI * 3 / 2

func focus_on_cages() -> void:
	if gate:
		gate.blur_all()
		
		if data.coord.y == 0:
			gate.unblur_col(data.coord.x-1)
		else:
			gate.unblur_row(data.coord.y-1)
	if abyss:
		abyss.blur_all()
		
		if data.coord.y == 0:
			abyss.unblur_col(data.coord.x-1)
		else:
			abyss.unblur_row(data.coord.y-1)

func _on_is_selected_changed() -> void:
	visible = data.is_selected
	
	if gate:
		gate.shackle_button.visible = data.is_selected
	
	if data.is_selected:
		focus_on_cages()
	
		if jail:
			jail.catena_timer.stop()
			jail.catena_timer.start()

func show_me() -> void:
	visible = true

func _on_z_index_changed() -> void:
	z_index = data.z_index
