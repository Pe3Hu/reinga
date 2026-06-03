class_name Sanctuary
extends Control


@export var world: World


func _ready():
	update_size()

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	size = viewport_size
	%MatrixRect.size = Vector2.ONE * max(size.x, size.y) * 0.9
	%MatrixRect.position = size / 2 - %MatrixRect.size / 2

func off_screen() -> void:
	visible = false

func on_screen():
	visible = true
