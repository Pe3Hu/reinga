extends Node


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	Global.node.hell = Global.scene.hell.instantiate()
	$Layer0.add_child(Global.node.hell)
	
	Global.node.arena = Global.node.hell.arenas.get_child(0)
	Global.node.arena.make_round()


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					Global.node.arena.make_round()


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
