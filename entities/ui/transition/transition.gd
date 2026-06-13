class_name Transition
extends CanvasLayer



var data: TransitionData:
	set(value_):
		data = value_
		data.next_layer_changed.connect(animate_in)

@export var world: World
@export var bg: ColorRect

var tween: Tween

func _ready() -> void:
	#data.current_layer = Scope.layer
	bg.material.set_shader_parameter("node_resolution", bg.size)

#region animate
func animate_in() -> void:
	if !data.skip_animation:
		visible = true
		tween = create_tween()
		get_tree().paused = true
		tween.tween_property(bg.material, "shader_parameter/factor", 1, Catalog.TRANSITION_DURATION)\
		 .set_trans(Tween.TRANS_QUAD)\
		 .set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		animate_out()
	else:
		no_animation()

func animate_out() -> void:
	apply_layer()
	
	tween = create_tween()
	tween.tween_property(bg.material, "shader_parameter/factor", 0.0, Catalog.TRANSITION_DURATION)\
	 .set_trans(Tween.TRANS_QUAD)\
	 .set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	get_tree().paused = false
	visible = false

func no_animation() -> void:
	apply_on_screen()
#endregion

#region apply
func apply_off_screen() -> void:
	if data.current_layer != Bozo.Layer.NONE:
		var node = world.get(Catalog.layer_to_string[data.current_layer])
		node.off_screen()

func apply_on_screen() -> void:
	if data.next_layer != Bozo.Layer.NONE:
		var node = world.get(Catalog.layer_to_string[data.next_layer])
		node.on_screen()

func apply_layer() -> void:
	apply_off_screen()
	apply_on_screen()
	data.reset()
	world.inferno.apply_layer()
#endregion
