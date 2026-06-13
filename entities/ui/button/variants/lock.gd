extends CustomButton


@export var bank: Bank


func update_visible() -> void:
	super.update_visible()
	visible = bank.data.hell.jail.table.active_cages.size() > 0


func _on_pressed() -> void:
	lock()

func lock() -> void:
	if !bank.hell.jail.data.table.active_cages.is_empty():
		hide_me()
		#bank.hell.jail.data.table.is_locked = true
		bank.hell.treasury.hide_not_selected_contributions()
		bank.hell.jail.data.table.reset_catenas(true)
		Scope.next_phase()
		#bank.hell.jail.forget_cage()
