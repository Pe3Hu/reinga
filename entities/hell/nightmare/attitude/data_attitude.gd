class_name AttitudeData
extends TypeData


var trial: TrialData
var bowls: Array[BowlData]
var blob_to_bowls: Dictionary
var shifts: Array[int]

var tooltip: Bozo.Tooltip = Bozo.Tooltip.ATTITUIDE
var type: Bozo.Attitude = Bozo.Attitude.INDIFFERENCE:
	set(value_):
		type = value_
		emit_signal("type_changed")
var ban_type: Bozo.Attitude
var privilege_type: Bozo.Attitude


#region init
func _init(trial_: TrialData) -> void:
	trial = trial_
	init_bowls()
	
func init_bowls() -> void:
	add_bowl(Bozo.Blob.MINUS, Bozo.Side.LEFT)
	add_bowl(Bozo.Blob.PLUS, Bozo.Side.RIGHT)

func add_bowl(type_: Bozo.Blob, side_: Bozo.Side) -> void:
	var bowl = BowlData.new(self, type_, side_)
	bowls.append(bowl)
	blob_to_bowls[type_] = bowl
#endregion
