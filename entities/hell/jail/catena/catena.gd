extends Control
class_name Catena


var jail: Jail
var gate: Gate
var type: Bozo.Catena
var coord: Vector2i

var cages: Array[Cage]


func setup(owner_: Variant, coord_: Vector2i, type_: Bozo.Catena):
	if owner_ is Jail:
		jail = owner_
	if owner_ is Gate:
		gate = owner_
	coord = coord_
	type = type_
	
	reset_lightning()

func reset_lightning() -> void:
	%Lightning.material = ShaderMaterial.new()
	%Lightning.material.shader = load("uid://xdi5lmvmean2")
	%Lightning.material.set_shader_parameter("seed", randf() * 100.0)
	
	if coord.y == 0:
		position.x = Catalog.CAGE_SIZE.x * (coord.x - 1)
		%Lightning.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.JAIL_SIZE.y)
	else:
		position.y = Catalog.CAGE_SIZE.y * coord.y  
		%Lightning.size = Vector2(Catalog.CAGE_SIZE.y, Catalog.JAIL_SIZE.x)
		%Lightning.rotation = PI * 3 / 2

func highligh_cages() -> void:
	for cage in cages:
		cage.status = Bozo.Cage.MIDDLE

func focus_on_cages() -> void:
	gate.blur_all()
	if  coord.y == 0:
		gate.unblur_col(coord.x-1)
	else:
		gate.unblur_row(coord.y-1)
