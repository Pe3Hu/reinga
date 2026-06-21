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
	sync_cage_sinners()
	ensure_cages_visible()
	if Scope.phase != Bozo.Phase.REPLENISHMENT:
		apply_cages_visibility()

func sync_cage_sinners() -> void:
	var sinners = hell.world.data.tribunal.actual.sinners
	
	for _i in sinners.size():
		var sinner_data = sinners[_i]
		var cage = cages[_i]
		cage.data.sinner = sinner_data
		sinner_data.cage = cage.data
		cage.sinner.data = sinner_data
		cage.cloak.dream.data = sinner_data.dream
	
	for _i in range(sinners.size(), cages.size()):
		var cage = cages[_i]
		cage.data.sinner = null
		cage.sinner.data = null
		cage.cloak.dream.data = null
		cage.cloak.dream.reset_all_desire_tokens()
	
	update_status_omens()

func update_status_omens() -> void:
	for cage in cages:
		if cage.sinner.data == null:
			continue
		for omen_data in cage.sinner.soul.doom.data.omens:
			omen_data.update_status(cage.data)

func ensure_cages_visible() -> void:
	%Cages.visible = Scope.phase != Bozo.Phase.DISBURSEMENT

func apply_cages_visibility() -> void:
	for cage in cages:
		cage.apply_cage_visibility()

func apply_phase_visiblity() -> void:
	ensure_cages_visible()
	apply_cages_visibility()

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
		cage.apply_cage_visibility()

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
		catena_timer.wait_time = randf_range(Gear.catena_mins[Gear.tempo], Gear.catena_maxs[Gear.tempo])
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

func apply_sun_layout_all() -> void:
	for cage in cages:
		cage.apply_sun_layout()

func apply_moon_layout_all(show_desires_: bool = true) -> void:
	for cage in cages:
		if cage.sinner.data != null or cage.data.sinner != null:
			cage.apply_moon_layout(show_desires_)

func dissolve_guilds() -> void:
	var pending = 0
	
	for cage in cages:
		if cage.sinner.data == null:
			cage.apply_sun_layout()
			continue
		if cage.sinner.fate.data.association != Bozo.Association.GUILD:
			cage.apply_sun_layout()
			continue
		
		pending += cage.cloak.dream.prepare_guild_dissolve()
		cage.apply_moon_layout(false)
	
	hell.nightmare.begin_guild_dissolves(pending)
	
	for cage in cages:
		if cage.sinner.data == null:
			continue
		if cage.sinner.fate.data.association == Bozo.Association.GUILD:
			cage.cloak.dream.start_guild_dissolve()

func update_visiblity_omens() -> void:
	var is_cage_selected = !data.table.active_cages.is_empty()
	
	for cage in cages:
		cage.sinner.soul.doom.apply_select_visiblity(is_cage_selected)

func apply_weather() -> void:
	for cage in cages:
		cage.apply_weather()
