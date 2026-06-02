class_name Transition
extends CanvasLayer


@export var bg: ColorRect

var tween: Tween

func _ready() -> void:
	bg.material.set_shader_parameter("node_resolution", bg.size)
	animate_in()
	

func animate_in() -> void:
	tween = create_tween()
	get_tree().paused = true
	tween.tween_property(bg.material, "shader_parameter/factor", 1, Catalog.TRANSITION_DURATION)
	tween.chain().tween_property(bg.material, "shader_parameter/factor", 0.0, Catalog.TRANSITION_DURATION)
	await tween.finished
	get_tree().paused = false

func animate_out() -> void:
	pass
