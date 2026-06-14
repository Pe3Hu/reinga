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
@export var platform: Platform

@export var eye_button: CustomButton
@export var weather_button: TextureButton


func _ready():
	Scope.phase_timer = %PhaseTimer
	update_size()


func connect_datas() -> void:
	nightmare.data = data.nightmare
	jail.data = data.jail
	treasury.data = data.treasury
	bank.data = data.bank
	market.data = data.market
	#shelter.data = data.shelter
	platform.data = data.jail.platform

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%UI.position = -%UI.size / 2

func simulate_choice() -> void:
	var contribution = treasury.contributions.back()
	jail.data.table._on_cage_gate_selected(contribution.cage.data)
	bank.lock()
	#await get_tree().create_timer(1).timeout
	#Scope.next_phase()

func execute_phase() -> void:
	if Scope.is_pause: return
	#if Scope.turn == 1: return
	
	match Scope.phase:
		Bozo.Phase.ENDOWMENT:
			Scope.next_phase()
		Bozo.Phase.REPLENISHMENT:
			world.data.tribunal.refill_actual()
			jail.update_sinner_datas()
			Scope.next_phase()
		Bozo.Phase.PAYMENT:
			nightmare.awaken_dreams()
		Bozo.Phase.APPRAISEMENT:
			treasury.appraisement_preparation()
			jail.dissolve_guilds()
			volcano.flow_plaza_update()
			#simulate_choice()
		Bozo.Phase.DISBURSEMENT:
			platform.apply_performances()
			treasury.hide_not_selected_contributions()
			jail.apply_phase_visiblity()
			volcano.flow_contribution_update()
		Bozo.Phase.DEVELOPMENT:
			market.data.refill_closed_deals()
			nightmare.start_drain_tributes()
		Bozo.Phase.INVESTMENT:
			weather_button.switch_weather()
			reset()
			world.data.tribunal.actual.clear()
			
			if world.data.tribunal.is_enough():
				Scope.next_phase()
			else:
				world.data.transition.next_layer = Bozo.Layer.GATE

func _on_phase_timer_timeout() -> void:
	execute_phase()

func reset() -> void:
	nightmare.reset()
	jail.reset()
	treasury.reset()
	bank.reset()
	platform.reset()

#func _process(_delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#Scope.update_phase()
		#execute_phase()

func off_screen() -> void:
	%PhaseTimer.stop()
	visible = false

func on_screen():
	%PhaseTimer.start()
	visible = true
	Scope.weather = Bozo.Weather.MOON
	weather_button.switch_weather()
