class_name World
extends Node



var data = WorldData.new()

@export var inferno: Inferno
@export var hell: Hell
@export var gate: Gate
@export var sanctuary: Sanctuary
@export var abyss: Abyss
@export var museum: Museum
@export var herald: Herald
@export var transition: Transition
@export var menu: MainMenu
@export var ascension: Ascension


func new_game() -> void:
	menu.visible = false
	Scope.is_game = true
	data = WorldData.new()
	connect_datas()
	
	inferno.apply_layer()
	Cycle.start()

func _ready() -> void:
	Cycle.hell = hell
	new_game()
	
	#await get_tree().process_frame
	#transition.data.next_layer = Bozo.Layer.HERALD

func connect_datas() -> void:
	sanctuary.data = data.sanctuary
	hell.data = data.hell
	gate.data = data.gate
	abyss.data = data.abyss
	museum.data = data.museum
	herald.data = data.herald
	transition.data = data.transition

func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE:
				switch_menu()
			KEY_1:
				transition.data.next_layer = Bozo.Layer.HELL
			KEY_2:
				transition.data.next_layer = Bozo.Layer.GATE
			KEY_3:
				transition.data.next_layer = Bozo.Layer.ABYSS
			KEY_4:
				transition.data.next_layer = Bozo.Layer.ASCENSION
			KEY_Q:
				data.tribunal.print_total_sinners()

func switch_menu() -> void:
	if !menu.visible:
		menu.on_screen()
	else:
		menu.off_screen()
