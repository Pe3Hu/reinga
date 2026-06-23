class_name EruptionData
extends Resource


var flow: FlowData
var token: Bozo.Token
var pressure: PressureData
var type: Bozo.Eruption
var trait_data: TraitData
var status: Bozo.Status = Bozo.Status.ON
var disbursement: bool
var from_safe: bool
#var modifier: Bozo.Modifier = Bozo.Modifier.NONE


func _init(flow_: FlowData, token_: Bozo.Token, type_: Bozo.Eruption, modifier_: Bozo.Modifier = Bozo.Modifier.NONE) -> void:
	flow = flow_
	token = token_
	type = type_
	pressure = PressureData.new(self, modifier_)
