class_name Gate
extends Control


var data: GateData:
	set(value_):
		data = value_
		init_cages()
		init_catenas()

@export var cage_scene: PackedScene
@export var catena_scene: PackedScene

@export var world: World



#region init
func _ready():
	update_size()

func update_size() -> void:
	#var viewport_size = get_viewport_rect().size
	#set_deferred("size", Vector2(viewport_size.x, viewport_size.y))
	#size = viewport_size
	pass

func init_cages() -> void:
	for cage_data in data.table.cages:
		add_cage(cage_data)

func init_catenas() -> void:
	for catena_data in data.table.catenas:
		add_catena(catena_data)

func add_catena(data_: CatenaData) -> void:
	var catena = catena_scene.instantiate()
	catena.data = data_
	%Catenas.add_child(catena)

func add_cage(data_: CageData) -> void:
	var cage = cage_scene.instantiate()
	cage.data = data_
	%Cages.add_child(cage)
#endregion

#func _on_cage_selected(cage_: Cage):
	#if !active_cages.is_empty():
		#var cage = active_cages.front()
		#cage.sinner.fate.unfocus()
	#
	#if !active_cages.has(cage_):
		#active_cages.append(cage_)
		#cage_.sinner.fate.focus()
		#
		#detect_catena()
#
#func detect_catena() -> void:
	#while active_cages.size() > 2:
		#active_cages.pop_front()
	#
	#if active_cages.size() != 2: return
	#var a = active_cages.front()
	#var b = active_cages.back()
	#
	#if a.col == b.col:
		#active_catena = a.col
		#return
	#
	#if a.row == b.row:
		#active_catena = a.row
		#return
	#
	#active_cages.pop_front()
	#active_catena = null
#
#func blur_all() -> void:
	#%Blur.visible = true
	#%Blur.material.set_shader_parameter("selected_row", -1)
	#%Blur.material.set_shader_parameter("selected_col", -1)
#
#func unblur_all() -> void:
	#%Blur.visible = false
#
#func unblur_row(index_: int) -> void:
	#%Blur.material.set_shader_parameter("selected_row", index_)
#
#func unblur_col(index_: int) -> void:
	#%Blur.material.set_shader_parameter("selected_col", index_)


func open() -> void:
	if !data.is_open: return
