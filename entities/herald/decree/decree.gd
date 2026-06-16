class_name Decree
extends PanelContainer


var data: DecreeData:
	set(value_):
		data = value_
		connect_datas()

#@export var law_scene: PackedScene

@export var herald: Herald
@export var laws: Array[Law]
@export var accept_button: CustomButton


#func add_law(law_data: LawData) -> void:
	#var law = law_scene.instantiate()
	#%Laws.add_child(law)
	#law.data = law_data


func connect_datas() -> void:
	reset_laws()
	
	%Header.text = data.header_text
	herald.update_background()
	%Frame.modulate = Catalog.blob_to_color[data.blob]
	accept_button.visible = true
	
	for _i in data.laws.size():
		var law = laws[_i]
		var law_data = data.laws[_i]
		law.data = law_data

func reset_laws() -> void:
	for law in laws:
		law.visible = false
