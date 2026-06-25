class_name MainMenu
extends Control


@export var world: World

@export var start: CustomButton
@export var unpause: CustomButton
@export var settings: CustomButton
@export var exit: CustomButton

@export var setting_tabs: TabContainer
@export var menu_panel: MarginContainer

var is_echo: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func off_screen() -> void:
	visible = false

func on_screen():
	get_tree().paused = true
	visible = true
	
	start.visible = !Scope.is_game
	unpause.visible = Scope.is_game

func _input(event) -> void:
	if event is InputEventKey and not event.pressed:
		match event.keycode:
			KEY_ESCAPE:
				if Scope.is_game:
					world.switch_menu()
			KEY_SPACE:
				if Scope.is_game:
					hide_settings()

func show_settings() -> void:
	menu_panel.visible = false
	setting_tabs.visible = true

func hide_settings() -> void:
	menu_panel.visible = true
	setting_tabs.visible = false
