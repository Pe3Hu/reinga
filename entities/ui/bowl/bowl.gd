@tool
class_name Bowl
extends Control


var data: BowlData:
	set(value_):
		data = value_
		connect_datas()
		apply_data_info()

@export var attitude: Attitude
@export var blobs: Array[Blob]



func connect_datas() -> void:
	for _i in blobs.size():
		var blob =  blobs[_i]
		var data_blob = data.blobs[_i]
		blob.data = data_blob

func apply_data_info() -> void:
	data.side_changed.connect(_on_side_changed)
	data.value_changed.connect(_on_value_changed)
	data.is_flipped_changed.connect(_on_is_flipped_changed)
	_on_side_changed()
	_on_value_changed()
	#_on_is_flipped_changed()

func _on_side_changed() -> void:
	if is_node_ready():
		match data.side:
			Bozo.Side.LEFT:
				%Blobs.move_child(%SideBlobs, 0)
				%Blobs.position = Vector2(0, 0)
			Bozo.Side.RIGHT:
				%Blobs.move_child(%CenterBlobs, 0)
				%Blobs.position = Vector2(size.x / 2, 0)

func _on_is_flipped_changed() -> void:
	var reverse_blobs = %CenterBlobs.get_children()
	reverse_blobs.reverse()
	
	for _i in reverse_blobs.size():
		%CenterBlobs.move_child(reverse_blobs[_i], _i)
	
	reverse_blobs = %SideBlobs.get_children()
	reverse_blobs.reverse()
	
	for _i in reverse_blobs.size():
		%SideBlobs.move_child(reverse_blobs[_i], _i)

func _on_value_changed() -> void:
	var shift = data.value - data.previous_value
	switch_blob(shift)
	
	data.previous_value = data.value
	
	if data.value == Catalog.BOWL_LIMIT:
		attitude.drain_bowl(self)

func switch_blob(shift_: int) -> void:
	for _i in abs(shift_):
		var index = data.previous_value + _i
		if sign(shift_) == -1:
			index -= 1
		
		if index >= 0 and index < blobs.size() and index < data.blobs.size():
			data.blobs[index].is_active = shift_ > 0

func reset() -> void:
	data.reset()
	
	for blob_data in data.blobs:
		blob_data.is_active = false
