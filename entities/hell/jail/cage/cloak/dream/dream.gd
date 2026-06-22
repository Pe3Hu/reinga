class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		
		connect_signals()

@export var desire_scene: PackedScene

@export var cloak: Cloak
@export var primary_tokens: Array[TokenDesire]
@export var secondary_tokens: Array[TokenDesire]
@export var desires: Array[TokenDesire]

var dissolves: Array[TokenDesire]
var guild_dissolves: Array[TokenDesire]


#region init
func connect_signals() -> void:
	if !data: return
	if! data.desire_changed.is_connected(_on_desires_changed):
		data.desire_changed.connect(_on_desires_changed)
		_on_desires_changed()
		#cloak.visible = true

func _on_desires_changed() -> void:
	sync_desire_bindings()

func sync_desire_bindings() -> void:
	desires.clear()
	if !data: return
	refill_desires()
	
	primary_tokens.clear()
	secondary_tokens.clear()
	
	for child in %PrimaryDesires.get_children():
		primary_tokens.append(child)
	
	for child in %SecondaryDesires.get_children():
		secondary_tokens.append(child)
	
	primary_tokens.reverse()
	
	var _j = 0
	var primary_slots = data.type_to_count.get(data.primary_desire, 0)
	var secondary_slots = data.type_to_count.get(data.secondary_desire, 0)
	
	for _i in primary_slots:
		if _i >= primary_tokens.size() or _j >= data.desires.size(): break
		var token = primary_tokens[_i]
		token.dream = self
		token.data = data.desires[_j]
		desires.append(token)
		_j += 1
	
	for _i in secondary_slots:
		if _j >= data.desires.size(): break
		var token = secondary_tokens[_i]
		token.dream = self
		token.data = data.desires[_j]
		desires.append(token)
		_j += 1

func refill_desires() -> void:
	refill_primary_desires()
	refill_secondary_desires()

func refill_primary_desires() -> void:
	while %PrimaryDesires.get_child_count() > data.type_to_count[data.primary_desire]:
		var desire = %PrimaryDesires.get_child(0)
		desires.erase(desire)
		%PrimaryDesires.remove_child(desire)
	
	while %PrimaryDesires.get_child_count() < data.type_to_count[data.primary_desire]:
		add_primary()

func add_primary() -> TokenDesire:
	var desire = desire_scene.instantiate()
	%PrimaryDesires.add_child(desire)
	desires.push_front(desire)
	desire.dream = self
	primary_tokens.append(desire)
	return desire

func refill_secondary_desires() -> void:
	while %SecondaryDesires.get_child_count() > data.type_to_count[data.secondary_desire]:
		var desire = %SecondaryDesires.get_child(0)
		desires.erase(desire)
		%SecondaryDesires.remove_child(desire)
	
	while %SecondaryDesires.get_child_count() < data.type_to_count[data.secondary_desire]:
		add_secondary()

func add_secondary() -> TokenDesire:
	var desire = desire_scene.instantiate()
	%SecondaryDesires.add_child(desire)
	desires.push_back(desire)
	desire.dream = self
	secondary_tokens.append(desire)
	return desire
#endregion

func ensure_desires() -> void:
	if !data: return
	#if desires.is_empty() or %PrimaryDesires.get_child_count() == 0:
		#_on_desires_changed()
	#else:
	sync_desire_bindings()

#region dissolve
func count_payment_dissolve() -> int:
	ensure_desires()
	dissolves.clear()
	
	if !data: return 0
	
	for desire in desires:
		if !desire.data:
			continue
		if !desire.dream:
			desire.dream = self
		dissolves.append(desire)
	
	return dissolves.size()

func start_payment_dissolve() -> void:
	for desire in dissolves:
		if !desire.dream:
			desire.dream = self
		
		desire.payment_dissolve()

func end_payment_dissolve(desire_: TokenDesire) -> void:
	if !dissolves.has(desire_): return
	
	dissolves.erase(desire_)
	cloak.cage.apply_sun_layout()
	cloak.cage.jail.hell.nightmare.on_payment_desire_finished()

func prepare_guild_dissolve() -> int:
	ensure_desires()
	guild_dissolves.clear()
	reset_all_desire_tokens()
	
	if !data: return 0
	
	for token in _all_desire_tokens():
		if token.data and token.data.association == Bozo.Association.GUILD:
			if !token.dream:
				token.dream = self
			
			guild_dissolves.append(token)
	
	return guild_dissolves.size()

func start_guild_dissolve() -> void:
	for token in guild_dissolves:
		token.refill_progress()
		token.dissolve()

func end_guild_dissolve(desire_: TokenDesire) -> void:
	var trial_type: Bozo.Trial = Catalog.desire_to_trial[desire_.data.type]
	var trial = cloak.cage.jail.hell.nightmare.type_to_trial[trial_type]
	var _sign = -1
	
	if Catalog.enemy_fates.has(desire_.data.dream.sinner.fate.type):
		_sign *= -1
	
	cloak.cage.jail.hell.volcano.burst_splash(trial.flame.progression, 1, _sign)
	#desire_.texture_rect.visible = false
	cloak.cage.apply_sun_layout()
	cloak.cage.jail.hell.nightmare.on_guild_dissolve_finished()
#endregion

func show_desires() -> void:
	ensure_desires()
	
	for desire in desires:
		desire.refill_progress()

func reset_desires() -> void:
	for desire in desires:
		desire.reset()

func reset_all_desire_tokens() -> void:
	for token in _all_desire_tokens():
		token.reset()

func _all_desire_tokens() -> Array[TokenDesire]:
	var tokens: Array[TokenDesire] = []
	for child in %PrimaryDesires.get_children():
		if child is TokenDesire:
			tokens.append(child)
	for child in %SecondaryDesires.get_children():
		if child is TokenDesire:
			tokens.append(child)
	return tokens

func add_madness_desire() -> void:
	var token_data = data.add_madness_desire()
	
	sync_desire_bindings()
	show_desires()
	
	var madness_desire: TokenDesire
	
	for desire in desires:
		if desire.data == token_data:
			madness_desire = desire
			break
	
	madness_desire.appear()
	await get_tree().process_frame
