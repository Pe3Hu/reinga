@tool
class_name Bowl
extends Control


@export var type: Bozo.Blob:
	set(value_):
		type = value_
		update_blob_type()
@export var trial: Bozo.Trial:
	set(value_):
		trial = value_
		update_blob_trial()
@export var side: Bozo.Side:
	set(value_):
		side = value_
		update_vbox_order()

@export var blobs: Array[Blob]

@export_range(0, 6, 1) var value: int = 0:
	set(value_):
		var shift = value_ - value
		switch_blob(shift)
		value = value_

@export var is_flipped: bool = false:
	set(value_):
		#if is_flipped != value_:
		update_blob_order()
		is_flipped = value_


func update_blob_type() -> void:
	for blob in blobs:
		blob.type = type

func update_blob_trial() -> void:
	for blob in blobs:
		blob.trial = trial

func update_vbox_order() -> void:
	if is_node_ready():
		match side:
			Bozo.Side.LEFT:
				%Blobs.move_child(%SideBlobs, 0)
				%Blobs.position = Vector2(0, 0)
			Bozo.Side.RIGHT:
				%Blobs.move_child(%CenterBlobs, 0)
				%Blobs.position = Vector2(size.x / 2, 0)

func update_blob_order() -> void:
	var reverse_blobs = %CenterBlobs.get_children()
	reverse_blobs.reverse()
	
	for _i in reverse_blobs.size():
		%CenterBlobs.move_child(reverse_blobs[_i], _i)
	
	reverse_blobs = %SideBlobs.get_children()
	reverse_blobs.reverse()
	
	for _i in reverse_blobs.size():
		%SideBlobs.move_child(reverse_blobs[_i], _i)

func switch_blob(shift_: int) -> void:
	for _i in abs(shift_):
		var index = value + _i
		if sign(shift_) == -1:
			index -= 1
		
		if index >= 0 and index < blobs.size():
			var blob = blobs[index]
			blob.is_active = shift_ > 0
