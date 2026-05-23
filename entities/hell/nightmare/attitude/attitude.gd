@tool 
class_name Attitude
extends PanelContainer


@export var trial: Trial
@export var icon: TextureRect

@export var type: Bozo.Attitude:
	set(value_):
		type = value_
		if is_node_ready():
			icon.texture = load("res://entities/hell/nightmare/trial/images/%s.png" % Catalog.attitude_to_string[type]) 


@export var bowls: Array[Bowl]


func _ready() -> void:
	for bowl in bowls:
		bowl.side = bowl.side

func update_trial() -> void:
	icon.modulate = Catalog.trial_to_color[trial.type]
	
	for bowl in bowls:
		bowl.trial = trial.type
