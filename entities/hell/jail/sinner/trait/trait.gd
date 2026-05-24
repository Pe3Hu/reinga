@tool
class_name Trait
extends PanelContainer


@export var data: TraitData:
	set(value_):
		data = value_
		call_deferred("init_tokens")

@export var type: Bozo.Triat:
	set(value_):
		type = value_
		update_columns()


@export var tokens: Array[Token]

@export var token_grid: GridContainer

@export var sin_scene: PackedScene
@export var posture_scene: PackedScene

var is_selected: bool = true:
	set(value_):
		is_selected = value_
		%Blur.visible = !is_selected


func _ready() -> void:
	if sin_scene == null:
		sin_scene = load("res://entities/token/sin/sin.tscn")
	if posture_scene == null:
		posture_scene = load("res://entities/token/posture/posture.tscn")

func init_tokens() -> void:
	for sin_data in data.sins:
		add_sin(sin_data)
	for posture_data in data.postures:
		add_posture(posture_data)

func add_sin(data_: SinData) -> void:
	var token = sin_scene.instantiate()
	token.type = data_.type
	token.value = data_.value
	token_grid.add_child(token)
	tokens.append(token)
	update_columns()

func add_posture(data_: PostureData) -> void:
	var token = posture_scene.instantiate()
	token.type = data_.type
	token.value = data_.value
	token_grid.add_child(token)
	tokens.append(token)
	update_columns()
	
func update_columns():
	%BackBufferCopy.rect = Rect2(%Blur.position, %Blur.size)
	
	if  tokens.is_empty(): return
	token_grid.columns = 1
	if type == Bozo.Triat.FEAR or type == Bozo.Triat.GUILT:
		token_grid.columns = tokens.size()

func test_max_token_count() -> void:
	if !data.sins.is_empty():
		while tokens.size() < 3:
			add_sin(data.sins.front())
	
	if !data.postures.is_empty():
		while tokens.size() < 3:
			add_posture(data.postures.front())
