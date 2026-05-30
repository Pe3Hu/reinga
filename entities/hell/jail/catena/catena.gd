extends Control
class_name Catena


var data: CatenaData

var jail: Jail
var gate: Gate

func reset_lightning() -> void:
	%Lightning.material = ShaderMaterial.new()
	%Lightning.material.shader = load("uid://xdi5lmvmean2")
	%Lightning.material.set_shader_parameter("seed", randf() * 100.0)
	
	if data.coord.y == 0:
		position.x = Catalog.CAGE_SIZE.x * (data.coord.x - 1)
		%Lightning.size = Vector2(Catalog.CAGE_SIZE.x, Catalog.JAIL_SIZE.y)
	else:
		position.y = Catalog.CAGE_SIZE.y * data.coord.y  
		%Lightning.size = Vector2(Catalog.CAGE_SIZE.y, Catalog.JAIL_SIZE.x)
		%Lightning.rotation = PI * 3 / 2

#func highligh_cages() -> void:
	#for cage in cages:
		#cage.status = Bozo.Cage.MIDDLE

func focus_on_cages() -> void:
	gate.blur_all()
	if data.coord.y == 0:
		gate.unblur_col(data.coord.x-1)
	else:
		gate.unblur_row(data.coord.y-1)
