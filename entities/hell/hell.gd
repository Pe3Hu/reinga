extends Node2D
class_name Planet


@onready var jail = %Jail
#@onready var horde = %Horde


func _ready():
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	jail.position = -Vector2(Catalog.JAIL_CAGE_SIZE) * Catalog.CAGE_SPRITE_SIZE / 2
