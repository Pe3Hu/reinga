extends CustomButton


@export var abyss: Abyss


func update_visible() -> void:
	super.update_visible()
	visible = abyss.data.table.active_cages.size() > 0

func _button_pressed() -> void:
	super._button_pressed()
	abyss.world.hell.bank.data.sacrifice = abyss.data.table.active_catenas.back().sacrifice
	abyss.data.refill_tribunal()
	hide_me()
	
	if Scope.exodus == 0:
		abyss.world.transition.data.next_layer = Bozo.Layer.HELL
	else:
		abyss.unblur_all()
