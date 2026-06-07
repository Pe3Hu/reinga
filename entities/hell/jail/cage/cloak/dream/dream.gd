class_name Dream
extends PanelContainer


var data: DreamData:
	set(value_):
		data = value_
		apply_data_info()

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
	for _i in desires.size():
		var desire = desires[_i]
		desire.data = data.desires[_i]
#endregion

#region dissolve
func start_dissolve_payment_tokens() -> void:
	dissolves.clear()
	cloak.cage.jail.hell.nightmare.dissolve_dreams.append(self)
	#dissolves.append_array(desires)
	
	for desire in desires:
		if desire.data.value > 0:
			dissolves.append(desire)
	
	for desire in desires:
		desire.dissolve()

func end_payment_dissolve(desire_: TokenDesire) -> void:
	dissolves.erase(desire_)
	
	if dissolves.is_empty():
		cloak.cage.jail.hell.nightmare.end_dream_dissolve_payment(self)

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
