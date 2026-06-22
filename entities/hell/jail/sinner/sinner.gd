@tool
extends Control
class_name Sinner


var data: SinnerData:
	set(value_):
		data = value_
		disconnect_signals()
		
		if data != null:
			%Header.visible = true
			connect_datas()
			connect_signals()
		else:
			%Header.visible = false

@export var cage: Cage

@export var faction: TokenFaction
@export var soul: Soul
@export var fate: Fate

var type: Bozo.Tooltip = Bozo.Tooltip.SINNER


func connect_datas() -> void:
	fate.data = data.fate
	faction.data = data.fate.faction
	soul.data = data.soul
	cage.cloak.dream.data = data.dream

func disconnect_signals() -> void:
	if data == null: return
	
	if data.is_fused.is_connected(_on_is_fused):
		data.is_fused.disconnect(_on_is_fused)
	if data.is_madness.is_connected(_on_is_madness):
		data.is_madness.disconnect(_on_is_madness)

func connect_signals() -> void:
	if data == null: return
	data.is_fused.connect(_on_is_fused)
	data.is_madness.connect(_on_is_madness)

func _on_is_fused() -> void:
	if cage.cloak.dream.data:
		cage.cloak.dream._on_desires_changed()
	soul.connect_datas()
	if Scope.layer == Bozo.Layer.MUSEUM:
		soul.show_all()

func _on_is_madness() -> void:
	if cage.jail == null or data == null or data.cage != cage.data: return

	if Scope.weather == Bozo.Weather.SUN:
		cage.jail.hell.weather_button.switch_weather()
		cage.jail.apply_phase_visiblity(true)
	
	cage.apply_weather()
	cage.cloak.dream.add_madness_desire()

func apply_phase_visiblity() -> void:
	cage.apply_cage_visibility()
