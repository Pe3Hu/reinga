extends Control
class_name Hell


@export var world: World
@export var volcano: Volcano
@export var nightmare: Nightmare
@export var jail: Jail
@export var treasury: Treasury



func _ready():
	Scope.phase_timer = %PhaseTimer
	update_size()

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%UI.position = -%UI.size / 2

func simulate_choice() -> void:
	jail.active_cage = treasury.contributions.back().cage
	treasury.lock()
	#await get_tree().create_timer(1).timeout
	Scope.next_phase()

func execute_phase() -> void:
	if Scope.is_pause: return
	#if Scope.turn == 1: return
	
	match Scope.phase:
		Bozo.Phase.ENDOWMENT:
			pass
		Bozo.Phase.REPLENISHMENT:
			world.tribunal.refill_actual()
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
			nightmare.refill_claims()
			world.tribunal.actual.clear()
			Scope.next_phase()
			#Scope.is_pause = true


func _on_phase_timer_timeout() -> void:
	execute_phase()
