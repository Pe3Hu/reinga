extends Control
class_name Hell


@export var inferno: Inferno
@export var volcano: Volcano
@export var nightmare: Nightmare
@export var jail: Jail
@export var treasury: Treasury

var tribunal = TribunalData.new()



func _ready():
	update_size()

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%UI.position = -%UI.size / 2
	inferno.resize_rect(viewport_size)

func simulate_choice() -> void:
	jail.active_cage = treasury.contributions.back().cage
	nightmare._on_lock_button_pressed()
	#nightmare._on_lock_button_pressed()
	await get_tree().create_timer(1).timeout
	Scope.in_progress = false
	Scope.next_phase()

func execute_phase() -> void:
	if Scope.is_pause: return
	if Scope.in_progress: return
	Scope.in_progress = false
	
	match Scope.phase:
		Bozo.Phase.ENDOWMENT:
			pass
		Bozo.Phase.REPLENISHMENT:
			tribunal.refill_actual()
			jail.apply_phase_visiblity()
			jail.update_sinner_datas()
		Bozo.Phase.PAYMENT:
			nightmare.awaken_dreams()
		Bozo.Phase.APPRAISEMENT:
			Scope.in_progress = true
			treasury.appraisement_preparation()
			#simulate_choice()
		Bozo.Phase.DISBURSEMENT:
			Scope.in_progress = true
			treasury.hide_not_selected_contributions()
			jail.apply_phase_visiblity()
			volcano.flow_update()
			volcano.burst_eruption()
		Bozo.Phase.INVESTMENT:
			tribunal.actual.clear()
	
	Scope.next_phase(!Scope.in_progress)


func _on_phase_timer_timeout() -> void:
	execute_phase()
