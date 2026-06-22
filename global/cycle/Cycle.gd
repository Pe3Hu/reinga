extends Node


var hell: Hell:
	set(value_):
		hell = value_
	
		init_phases()
var active: bool
var suspended: bool
var interrupt: Bozo.Interrupt = Bozo.Interrupt.NONE
var generation: int

var type_to_phase: Dictionary


func start() -> void:
	if hell == null:
		push_error("HellCycle.start() called before bind()")
		return
	
	active = true
	suspended = false
	interrupt = Bozo.Interrupt.NONE
	Scope.phase = Bozo.Phase.ENDOWMENT
	generation  = 0
	_enter_current()

func can_run_phase(phase_type: Bozo.Phase) -> bool:
	return active \
		and !suspended \
		and Scope.layer == Bozo.Layer.HELL \
		and Scope.phase == phase_type

func complete_phase() -> void:
	if !active or suspended:
		return
	
	if Scope.layer != Bozo.Layer.HELL:
		return
	
	_finish_current()

func suspend(interrupt_: Bozo.Interrupt) -> void:
	if suspended:
		return
	
	suspended = true
	interrupt = interrupt_
	get_phase(Scope.phase).exit()
	hell.nightmare.abort_payment()

func resume(interrupt_: Bozo.Interrupt) -> void:
	if !suspended:
		return
	
	suspended = false
	interrupt = Bozo.Interrupt.NONE
	
	match interrupt_:
		Bozo.Interrupt.GATE_RECRUIT:
			if Scope.phase != Bozo.Phase.PREFERMENT:
				push_warning("HellCycle resume GATE_RECRUIT at phase %s" % Catalog.phase_to_string[Scope.phase])
			_advance()
			_enter_current()
		Bozo.Interrupt.HERALD_DECREE:
			if Scope.phase != Bozo.Phase.DEVELOPMENT:
				push_warning("HellCycle resume HERALD_DECREE at phase %s" % Catalog.phase_to_string[Scope.phase])
			_advance()
			_enter_current()
		Bozo.Interrupt.ABYSS_SACRIFICE:
			#push_warning("HellCycle resume ABYSS_SACRIFICE is not implemented")
			
			Cycle.prepare_new_turn()
			_advance()
			_enter_current()
		Bozo.Interrupt.MUSEUM_REALIZE:
			if Scope.phase != Bozo.Phase.DEVELOPMENT:
				push_warning("HellCycle resume MUSEUM_REALIZE at phase %s" % Catalog.phase_to_string[Scope.phase])
			#push_warning("HellCycle resume MUSEUM_REALIZE is not implemented")
			_advance()
			_enter_current()
		_:
			push_warning("HellCycle resume unknown interrupt %s" % interrupt_)

func init_phases() -> void:
	type_to_phase = {
		Bozo.Phase.ENDOWMENT: Endowment.new(),
		Bozo.Phase.REPLENISHMENT: Replenishment.new(),
		Bozo.Phase.PAYMENT: Payment.new(),
		Bozo.Phase.APPRAISEMENT: Appraisement.new(),
		Bozo.Phase.DISBURSEMENT: Disbursement.new(),
		Bozo.Phase.DEVELOPMENT: Development.new(),
		Bozo.Phase.PREFERMENT: Preferment.new(),
		Bozo.Phase.INVESTMENT: Investment.new(),
	}

func get_phase(phase_type_: Bozo.Phase) -> Phase:
	return type_to_phase.get(phase_type_, type_to_phase[Bozo.Phase.ENDOWMENT])

func _enter_current() -> void:
	if !active or suspended: return
	if Scope.layer != Bozo.Layer.HELL: return
	
	generation += 1
	var phase = get_phase(Scope.phase)
	phase.enter()
	
	if suspended: return
	
	if !phase.is_async():
		_finish_current()

func _finish_current() -> void:
	var phase = get_phase(Scope.phase)
	phase.exit()
	_advance()
	
	if suspended: return
	
	_enter_current()

func _advance() -> void:
	Scope.phase = Catalog.phase_to_next[Scope.phase]
	#print([Scope.turn, Catalog.phase_to_string[Scope.phase]])
	
	if Scope.phase == Bozo.Phase.REPLENISHMENT:
		Scope.turn += 1

func prepare_new_turn() -> void:
	hell.world.data.tribunal.refill_actual()
	hell.jail.update_sinner_datas()
