class_name EruptionData
extends Resource


var flow: FlowData
var token: Bozo.Token
var pressure: PressureData
var type: Bozo.Eruption
#var modifier: Bozo.Modifier = Bozo.Modifier.NONE


func _init(flow_: FlowData, token_: Bozo.Token, type_: Bozo.Eruption, modifier_: Bozo.Modifier = Bozo.Modifier.NONE) -> void:
	flow = flow_
	token = token_
	type = type_
	pressure = PressureData.new(self, modifier_)
