extends Phase
class_name Disbursement


func get_type() -> Bozo.Phase:
	return Bozo.Phase.DISBURSEMENT

func is_async() -> bool:
	return true

func enter() -> void:
	Cycle.hell.platform.apply_performances()
	Cycle.hell.treasury.hide_not_selected_contributions()
	Cycle.hell.jail.apply_phase_visiblity()
	await Cycle.hell.volcano.wait_eruption_pool_idle()
	Cycle.hell.volcano.flow_contribution_update()
