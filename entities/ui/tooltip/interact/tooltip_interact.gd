class_name TooltipInteract
extends Control

@export var target: Control

var tooltip: Tooltip


func _ready():
	mouse_entered.connect(_on_enter)
	mouse_exited.connect(_on_exit)

	if target == null:
		target = self


func _on_enter():
	var d := TooltipData.new()
	d.type = Catalog.type_to_tooltip[target.type]
	d.text = TooltipManager.get_template(d.type)
	
	match d.type:
		Bozo.Tooltip.SIN:
			d.text = d.text % Catalog.sin_to_string[target.type].capitalize()
			
			if target.get_parent().get_parent() is Claim:
				d.text = d.text.replace("Produces", "Consumes")
		#Bozo.Tooltip.MADNESS:
			#d.text = d.text % Catalog.posture_to_string[target.type]
		#Bozo.Tooltip.OBLIVION:
			#d.text = d.text % Catalog.posture_to_string[target.type]
	
	d.text = Catalog.tooltip_to_string[d.type].capitalize() + "\n" + d.text
	tooltip = TooltipManager.show_root(
		d,
		target.get_global_rect()
	)


func _on_exit():
	await get_tree().create_timer(0.05).timeout

	if tooltip == null:
		return

	var mouse := get_viewport().get_mouse_position()

	if tooltip._is_mouse_in_interest_area(mouse):
		return

	tooltip.destroy_branch()
