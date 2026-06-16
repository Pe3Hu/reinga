class_name HeraldData
extends Resource


var decrees: Array[DecreeData]


func _init() -> void:
	test_decrees()

func test_decrees() -> void:
	var overlords = [
		Bozo.Overlord.VIRELLO
	]
	
	var blobs = [
		Bozo.Blob.PLUS
	]
	
	for _i in overlords.size():
		var overlord = overlords[_i]
		var blob = blobs[_i]
		add_decree(overlord, blob)

func add_decree(overlord_: Bozo.Overlord, blob_: Bozo.Blob) -> void:
	var decree = DecreeData.new(self, overlord_, blob_)
	decrees.append(decree)
