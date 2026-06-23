class_name Decree
extends PanelContainer


var data: DecreeData:
	set(value_):
		data = value_
		connect_datas()

@export var herald: Herald
@export var laws: Array[Law]
@export var accept_button: CustomButton


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
	
	simulate_accept()

func reset_laws() -> void:
	for law in laws:
		law.visible = false

func simulate_accept() -> void:
	if !Scope.is_skip: return
	
	var duration = Gear.simulates[Gear.tempo] * 0.25
	%AcceptTimer.wait_time = duration
	%AcceptTimer.start()

func _on_accept_timer_timeout() -> void:
	accept_button._button_pressed()
