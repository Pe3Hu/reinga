class_name Inferno
extends Node2D


func resize_rect(size_: Vector2) -> void:
	var vec3 = Vector3(size_.x * 0.5, size_.y * 0.5, 0)
	%AshParticles.process_material.set_emission_box_extents(vec3)
	%WindParticles.process_material.set_emission_box_extents(vec3)
	%Background.size = size_ 
	%Background.position = -size_ / 2
	
