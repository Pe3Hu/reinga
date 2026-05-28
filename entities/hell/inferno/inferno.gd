class_name Inferno
extends Node2D


@export var world: World


func _ready():
	update_size()

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	resize_rect(viewport_size)
	position =  viewport_size / 2

func resize_rect(size_: Vector2) -> void:
	var vec3 = Vector3(size_.x * 0.5, size_.y * 0.5, 0)
	%AshParticles.process_material.set_emission_box_extents(vec3)
	%WindParticles.process_material.set_emission_box_extents(vec3)
	%FireBackground.size = size_ 
	%FireBackground.position = -size_ / 2
	
	%VoidBackground.size = Vector2.ONE * max(size_.x, size_.y)
	%VoidBackground.position = -%VoidBackground.size * 0.5


func reset() -> void:
	%WindParticles.visible = false
	%AshParticles.visible = false
	%FireBackground.visible = false
	%VoidBackground.visible = false


func apply_layer() -> void:
	reset()
	
	match Scope.layer:
		Bozo.Layer.HELL:
			%WindParticles.visible = true
			%AshParticles.visible = true
			%FireBackground.visible = true
		Bozo.Layer.GATE:
			%VoidBackground.visible = true
