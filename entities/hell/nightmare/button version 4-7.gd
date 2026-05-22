extends Button

var tween: Tween


func _ready() -> void:
	mouse_entered.connect(hover)
	mouse_exited.connect(unhover)
	pivot_offset = Vector2(0.5, 0.5)

func hover() -> void:
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_parallel(true)

	tween.tween_property(self, "scale:x", 1.2, 0.1)
	tween.tween_property(self, "scale:y", 0.75, 0.13)

	var direction := 1.0 if randf() < 0.5 else -1.0
	var rot_variation: float = randf_range(5.0, 10.0) * direction
	tween.tween_property(self, "rotation_degrees", rot_variation, 0.1)

	tween.chain().set_parallel(true)
	tween.tween_property(self, "scale:x", 1.1, 0.15)
	tween.tween_property(self, "scale:y", 1.1, 0.15)
	tween.tween_property(self, "rotation_degrees", 0.0, 0.1)

func unhover() -> void:
	if tween and tween.is_running():
		tween.kill()

	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)

	tween.tween_property(self, "scale", Vector2.ONE, 0.15)
	tween.tween_property(self, "rotation_degrees", 0.0, 0.15)
