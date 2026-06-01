extends Control
class_name Hell


var data: HellData:
	set(value_):
		data = value_
		connect_datas()

@export var world: World
@export var volcano: Volcano
@export var nightmare: Nightmare
@export var jail: Jail
@export var treasury: Treasury

@export var bank: Bank
@export var market: Market
@export var shelter: Shelter


func _ready():
	Scope.phase_timer = %PhaseTimer
	update_size()


func connect_datas() -> void:
	nightmare.data = data.nightmare
	jail.data = data.jail
	treasury.data = data.treasury
	bank.data = data.bank
	market.data = data.market
	shelter.data = data.shelter

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%UI.position = -%UI.size / 2

func simulate_choice() -> void:
	var contribution = treasury.contributions.back()
	jail.data.table._on_cage_selected(contribution.cage.data)
	treasury.lock()
	#await get_tree().create_timer(1).timeout
	Scope.next_phase()

func execute_phase() -> void:
	if Scope.is_pause: return
	#if Scope.turn == 1: return
	
	match Scope.phase:
		Bozo.Phase.ENDOWMENT:
			Scope.next_phase()
		Bozo.Phase.REPLENISHMENT:
			world.data.tribunal.refill_actual()
			jail.apply_phase_visiblity()
			jail.update_sinner_datas()
			Scope.next_phase()
		Bozo.Phase.PAYMENT:
			nightmare.awaken_dreams()
		Bozo.Phase.APPRAISEMENT:
			treasury.appraisement_preparation()
			simulate_choice()
		Bozo.Phase.DISBURSEMENT:
			treasury.hide_not_selected_contributions()
			jail.apply_phase_visiblity()
			volcano.flow_update()
			volcano.burst_eruption()
		Bozo.Phase.DEVELOPMENT:
			nightmare.start_drain_tributes()
		Bozo.Phase.INVESTMENT:
			nightmare.data.refill_claims()
			world.data.tribunal.actual.clear()
			jail.reset()
			Scope.next_phase()
			#Scope.is_pause = true


func _on_phase_timer_timeout() -> void:
	execute_phase()

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Scope.update_phase()
		execute_phase()
