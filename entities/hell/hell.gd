extends Control
class_name Hell


var data: HellData:
	set(value_):
		data = value_
		connect_datas()

@export var world: World
@export var volcano: Volcano
@export var nightmare: Nightmare
@export var jail: Jail
@export var treasury: Treasury

@export var bank: Bank
@export var market: Market
@export var platform: Platform

@export var eye_button: TextureButton
@export var weather_button: TextureButton


func _ready():
	update_size()

func update_size() -> void:
	var viewport_size = get_viewport_rect().size
	position = viewport_size / 2
	%UI.position = -%UI.size / 2

func connect_datas() -> void:
	nightmare.data = data.nightmare
	jail.data = data.jail
	treasury.data = data.treasury
	bank.data = data.bank
	market.data = data.market
	platform.data = data.jail.platform

func reset() -> void:
	nightmare.reset()
	jail.reset()
	treasury.reset()
	bank.reset()
	platform.reset()

func off_screen() -> void:
	nightmare.abort_payment()
	nightmare.abort_guild()
	visible = false
	
	if world.transition.data.next_layer == Bozo.Layer.MUSEUM:
		jail.apply_madness_visibility()
	if world.transition.data.next_layer == Bozo.Layer.HERALD:
		jail.apply_madness_visibility()

func on_screen():
	visible = true
	bank.data.emit_signal("sacrifice_received")
	#Scope.weather = Bozo.Weather.MOON
	#weather_button.switch_weather()

func simulate_choice() -> void:
	if !Scope.is_skip: return
	var duration = Gear.simulates[Gear.tempo] * 2
	await get_tree().create_timer(duration).timeout
	var contribution = treasury.contributions.back()
	jail.data.table._on_cage_gate_selected(contribution.cage.data)
	bank.lock_button._button_pressed()
