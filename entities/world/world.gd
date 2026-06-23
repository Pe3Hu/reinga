class_name World
extends Node



var data = WorldData.new()
var pending_new_game: bool = false

@export var inferno: Inferno
@export var hell: Hell
@export var gate: Gate
@export var sanctuary: Sanctuary
@export var abyss: Abyss
@export var museum: Museum
@export var herald: Herald
@export var transition: Transition
@export var main_menu: MainMenu
@export var preparation_menu: PreparationMenu
@export var exodus: Exodus


func new_game() -> void:
	Cycle.stop()
	Scope.is_game = true
	pending_new_game = true
	
	data = WorldData.new()
	connect_datas()
	
	transition.data.current_layer = Bozo.Layer.MENU
	transition.data.next_layer = Bozo.Layer.HELL

func _ready() -> void:
	get_tree().paused = true
	Cycle.hell = hell
	

func connect_datas() -> void:
	sanctuary.data = data.sanctuary
	hell.data = data.hell
	gate.data = data.gate
	abyss.data = data.abyss
	museum.data = data.museum
	herald.data = data.herald
	transition.data = data.transition

func _input(event) -> void:
	if event is InputEventKey and not event.pressed:
		match event.keycode:
			KEY_SPACE:
				pass
			#KEY_1:
				#transition.data.next_layer = Bozo.Layer.HELL
			#KEY_2:
				#transition.data.next_layer = Bozo.Layer.GATE
			#KEY_3:
				#transition.data.next_layer = Bozo.Layer.ABYSS
			KEY_4:
				transition.data.next_layer = Bozo.Layer.EXODUS
			#KEY_Q:
			#	data.tribunal.print_total_sinners()

func switch_menu() -> void:
	if main_menu.is_echo:
		main_menu.is_echo = false
		return
	
	if !main_menu.visible:
		main_menu.on_screen()
	else:
		main_menu.off_screen()
		get_tree().paused = false
