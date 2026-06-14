extends PanelContainer
class_name Jail


var data: JailData:
	set(value_):
		data = value_
		init_cages()
		init_catenas()

@export var cage_scene: PackedScene
@export var catena_scene: PackedScene

@export var hell: Hell
@export var catena_timer: Timer

var cages: Array[Cage]


#region init
func init_cages() -> void:
	cages.clear()
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
	cage.jail = self
	%Cages.add_child(cage)
	cages.append(cage)
#endregion

func update_sinner_datas() -> void:
	apply_phase_visiblity()
	
	for _i in hell.world.data.tribunal.actual.sinners.size():
		var sinner_data = hell.world.data.tribunal.actual.sinners[_i]
		var cage = cages[_i]
		cage.data.sinner = sinner_data
		cage.sinner.data = sinner_data
		cage.cloak.dream.data = sinner_data.dream
	
	update_status_omens()

func update_status_omens() -> void:
	for cage in cages:
		for omen_data in cage.sinner.soul.doom.data.omens:
			omen_data.update_status()

func apply_phase_visiblity() -> void:
	%Cages.visible = true
	
	match Scope.phase:
		Bozo.Phase.DISBURSEMENT:
			%Cages.visible = false

func get_active_cage() ->  Variant:
	if data.table.active_cages.is_empty(): return null
	
	for cage in cages:
		if cage.data == data.table.active_cages.back():
			return cage
	
	return null

func reset() -> void:
	data.table.reset_all_actives()
	data.plaza.reset_associations()
	data.reset_traits()
	
	for cage in cages:
		cage.sinner.apply_phase_visiblity()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if not get_global_rect().has_point(get_global_mouse_position()):
				if !hell.bank.lock_button.is_mouse_inside():
					forget_cage()
			
			TooltipManager.clear()

func forget_cage() -> void:
	if Scope.layer == Bozo.Layer.HELL:
		data.table.reset_cage(true)
		data.table.reset_catenas()
		update_visiblity_omens()

func _on_catena_timer_timeout() -> void:
	if !data.table.active_catenas.is_empty():
		catena_timer.wait_time = randf_range(Catalog.CATENA_DURATION_MIN, Catalog.CATENA_DURATION_MAX)
		data.z_index_order += 1
		
		if data.z_index_order >= 10:
			data.z_index_order = 0
		
		for _i in data.table.active_catenas.size():
			var catena = data.table.active_catenas[_i]
			
			if data.z_index_order % 2 == _i % 2:
				catena.z_index = Catalog.CATENA_Z_INDEX_DEFAULT + 1
			else:
				catena.z_index = Catalog.CATENA_Z_INDEX_DEFAULT - 1
		
	#else:
		#catena_timer.stop()

func get_trait_token(token_data_: TokenData) -> Variant:
	for cage in cages:
		if token_data_.trait_data.soul.sinner.cage == cage.data:
			var _trait = cage.sinner.soul.get(Catalog.trait_to_string[token_data_.trait_data.type])
			
			for token in _trait.tokens:
				if token.data == token_data_:
					return token
	
	return null

func dissolve_guilds() -> void:
	for cage in cages:
		#cage.sinner.visible = true
		if cage.sinner.fate.data.association == Bozo.Association.GUILD:
			cage.cloak.dream.start_dissolve_guild_tokens()

func update_visiblity_omens() -> void:
	var is_cage_selected = !data.table.active_cages.is_empty()
	
	for cage in cages:
		cage.sinner.soul.doom.apply_select_visiblity(is_cage_selected)

func apply_weather() -> void:
	for cage in cages:
		cage.apply_weather()
