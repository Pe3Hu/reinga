extends CustomButton


@export var bank: Bank


func update_visible() -> void:
	super.update_visible()
	visible = bank.data.hell.jail.table.active_cages.size() > 0

func _button_pressed() -> void:
	super._button_pressed()
	lock()

func lock() -> void:
	if !bank.hell.jail.data.table.active_cages.is_empty():
		hide_me()
		bank.hell.treasury.hide_not_selected_contributions()
		bank.hell.jail.data.table.reset_catenas(true)
		Cycle.complete_phase()
		#bank.hell.jail.forget_cage()
