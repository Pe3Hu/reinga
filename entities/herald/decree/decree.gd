class_name Decree
extends PanelContainer


var data: DecreeData

#@export var law_scene: PackedScene

@export var laws: Array[Law]


#func add_law(law_data: LawData) -> void:
	#var law = law_scene.instantiate()
	#%Laws.add_child(law)
	#law.data = law_data
