extends Node


func _ready() -> void:
	#Global.obj.insel = Classes_0.Insel.new()
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012
	Global.node.hell = Global.scene.hell.instantiate()
	$Layer0.add_child(Global.node.hell)
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					pass


func _process(delta_) -> void:
	$FPS.text = str(Engine.get_frames_per_second())
