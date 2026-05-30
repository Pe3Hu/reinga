class_name BowlData
extends Resource


signal type_changed
signal side_changed
signal value_changed
signal is_flipped_changed

var attitude: AttitudeData
var type: Bozo.Blob:
	set(value_):
		type = value_
		emit_signal("type_changed")
var side: Bozo.Side:
	set(value_):
		side = value_
		emit_signal("side_changed")
var value: int = 0:
	set(value_):
		value = value_
		emit_signal("value_changed")
var is_flipped: bool = false:
	set(value_):
		is_flipped = value_
		emit_signal("is_flipped_changed")

var blobs: Array[BlobData]
var step: int = 0
var previous_value: int = 0

const BLOB_COUNT := 6


func _init(attitude_: AttitudeData, type_: Bozo.Blob, side_: Bozo.Side) -> void:
	attitude = attitude_
	type = type_
	side = side_
	init_blobs()

func init_blobs() -> void:
	for _i in range(BLOB_COUNT):
		blobs.append(BlobData.new(self))

func reset() -> void:
	value = 0
	
	for blob in blobs:
		blob.is_active = false
