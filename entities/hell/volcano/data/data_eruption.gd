class_name EruptionData
extends Resource


var flow: FlowData
var sin_type: Bozo.Sin
var trial_type: Bozo.Trial


func _init(flow_: FlowData, sin_type_: Bozo.Sin, trial_type_: Bozo.Trial) -> void:
	flow = flow_
	sin_type = sin_type_
	trial_type = trial_type_
