extends Phase
class_name Disbursement


func get_type() -> Bozo.Phase:
	return Bozo.Phase.DISBURSEMENT


func is_async() -> bool:
	return true


func enter() -> void:
	var hell := Cycle.hell
	hell.platform.apply_performances()
	hell.treasury.hide_not_selected_contributions()
	hell.jail.apply_phase_visiblity()
	await hell.volcano.wait_eruption_pool_idle()
	hell.volcano.flow_contribution_update()
