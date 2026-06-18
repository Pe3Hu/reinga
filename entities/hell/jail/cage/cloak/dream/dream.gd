class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		apply_data_info()

@export var desire_scene: PackedScene

@export var cloak: Cloak
#@export var primary_tokens: Array[TokenDesire]
#@export var secondary_token: TokenDesire
@export var desires: Array[TokenDesire]

var dissolves: Array[TokenDesire]


#region init
func apply_data_info() -> void:
	if !data: return
	if! data.desire_changed.is_connected(_on_desires_changed):
		data.desire_changed.connect(_on_desires_changed)
		_on_desires_changed()
		#cloak.visible = true

func _on_desires_changed() -> void:
	refill_desires()
	sync_desire_bindings()

func sync_desire_bindings() -> void:
	desires.clear()
	if !data:
		return
	
	var primary_nodes: Array[TokenDesire] = []
	for child in %PrimaryDesires.get_children():
		primary_nodes.append(child)
	primary_nodes.reverse()
	
	var data_i = 0
	var primary_slots = data.type_to_count.get(data.primary_desire, 0)
	for node_i in primary_slots:
		if node_i >= primary_nodes.size() or data_i >= data.desires.size():
			break
		var token = primary_nodes[node_i]
		token.dream = self
		token.data = data.desires[data_i]
		desires.append(token)
		data_i += 1
	
	for child in %SecondaryDesires.get_children():
		if data_i >= data.desires.size():
			break
		var token: TokenDesire = child
		token.dream = self
		token.data = data.desires[data_i]
		desires.append(token)
		data_i += 1

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

func add_primary() -> void:
	var desire = desire_scene.instantiate()
	%PrimaryDesires.add_child(desire)
	desires.push_front(desire)
	desire.dream = self

func refill_secondary_desires() -> void:
	while %SecondaryDesires.get_child_count() > data.type_to_count[data.secondary_desire]:
		var desire = %SecondaryDesires.get_child(0)
		desires.erase(desire)
		%SecondaryDesires.remove_child(desire)
	
	while %SecondaryDesires.get_child_count() < data.type_to_count[data.secondary_desire]:
		add_secondary()

func add_secondary() -> void:
	var desire = desire_scene.instantiate()
	%SecondaryDesires.add_child(desire)
	desires.push_back(desire)
	desire.dream = self
#endregion

#region dissolve
func begin_payment_dissolve() -> int:
	dissolves.clear()
	
	if !data:
		return 0
	
	var count = 0
	for desire in desires:
		if !desire.texture_rect.visible:
			continue
		dissolves.append(desire)
		desire.dissolve_payment()
		count += 1
	
	return count

func end_payment_dissolve(desire_: TokenDesire) -> void:
	if !dissolves.has(desire_):
		return
	
	dissolves.erase(desire_)
	cloak.cage.sinner.apply_phase_visiblity()
	cloak.cage.jail.hell.nightmare.on_payment_desire_finished()

func start_dissolve_guild_tokens() -> void:
	for token in desires:
		if token.data.association == Bozo.Association.GUILD:
			token.dissolve()

func end_dissolve_guild_tokens(desire_: TokenDesire) -> void:
	#desire_.texture_rect.visible = false
	var trial_type: Bozo.Trial = Catalog.desire_to_trial[desire_.data.type]
	var trial = cloak.cage.jail.hell.nightmare.type_to_trial[trial_type]
	var _sign = -1
	
	if Catalog.enemy_fates.has(desire_.data.dream.sinner.fate.type):
		_sign *= -1
	
	cloak.cage.jail.hell.volcano.burst_splash(trial.flame.progression, 1, _sign)
#endregion

func show_desires() -> void:
	for desire in desires:
		desire.refill_progress()

func reset_desires() -> void:
	for desire in desires:
		desire.reset()
