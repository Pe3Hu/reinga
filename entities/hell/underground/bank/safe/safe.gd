class_name Safe
extends PanelContainer


@export var amber: TokenAmber
@export var oblivion: TokenPosture
@export var madness: TokenPosture



func activate() -> void:
	%ActiveBackground.visible = true
	%PassiveBackground.visible = false

func deactivate() -> void:
	%ActiveBackground.visible = false
	%PassiveBackground.visible = true
