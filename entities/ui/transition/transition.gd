class_name Transition
extends CanvasLayer



var data: TransitionData:
	set(value_):
		data = value_
		data.next_layer_changed.connect(animate_in)

@export var world: World
@export var bg: ColorRect

var tween: Tween
var _pending_cycle_interrupt: Bozo.Interrupt = Bozo.Interrupt.NONE


func _ready() -> void:
	#data.current_layer = Scope.layer
	bg.material.set_shader_parameter("node_resolution", bg.size)

#region animate
func animate_in() -> void:
	if !data.skip_animation:
		visible = true
		tween = create_tween()
		get_tree().paused = true
		tween.tween_property(bg.material, "shader_parameter/factor", 1, Gear.transitions[Gear.tempo])\
		 .set_trans(Tween.TRANS_QUAD)\
		 .set_ease(Tween.EASE_IN_OUT)
		await tween.finished
		animate_out()
	else:
		no_animation()

func animate_out() -> void:
	apply_layer()
	
	tween = create_tween()
	tween.tween_property(bg.material, "shader_parameter/factor", 0.0, Gear.transitions[Gear.tempo])\
	 .set_trans(Tween.TRANS_QUAD)\
	 .set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	get_tree().paused = false
	_resume_cycle()
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
	if !Scope.is_game: return
	
	if data.next_layer != Bozo.Layer.NONE:
		var node = world.get(Catalog.layer_to_string[data.next_layer])
		node.on_screen()

func apply_layer() -> void:
	var from_layer = data.current_layer
	apply_off_screen()
	apply_on_screen()
	data.reset()
	
	_pending_cycle_interrupt = Bozo.Interrupt.NONE
	if data.current_layer == Bozo.Layer.HELL:
		match from_layer:
			Bozo.Layer.HERALD:
				_pending_cycle_interrupt = Bozo.Interrupt.HERALD_DECREE
			Bozo.Layer.GATE:
				_pending_cycle_interrupt = Bozo.Interrupt.GATE_RECRUIT
			Bozo.Layer.ABYSS:
				_pending_cycle_interrupt = Bozo.Interrupt.ABYSS_SACRIFICE
			Bozo.Layer.MUSEUM:
				_pending_cycle_interrupt = Bozo.Interrupt.MUSEUM_REALIZE
	
	world.inferno.apply_layer()

func _resume_cycle() -> void:
	if _pending_cycle_interrupt == Bozo.Interrupt.NONE:
		return
	
	var interrupt = _pending_cycle_interrupt
	_pending_cycle_interrupt = Bozo.Interrupt.NONE
	Cycle.resume(interrupt)
#endregion
