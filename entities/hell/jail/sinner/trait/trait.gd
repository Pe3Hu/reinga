@tool
class_name Trait
extends PanelContainer


var data: TraitData:
	set(value_):
		data = value_
		connect_signals()

@export var tokens: Array[Token]

@export var token_grid: GridContainer

@export var sin_scene: PackedScene
@export var posture_scene: PackedScene



#region init
func _ready() -> void:
	if sin_scene == null:
		sin_scene = load("res://entities/token/sin/sin.tscn")
	if posture_scene == null:
		posture_scene = load("res://entities/token/posture/posture.tscn")

func init_tokens() -> void:
	reset_tokens()
	
	for sin_data in data.sins:
		add_sin(sin_data)
	for posture_data in data.postures:
		add_posture(posture_data)
	
	_on_type_changed()
	update_tooltipe_size()

func reset_tokens() -> void:
	while !tokens.is_empty():
		var token = tokens.pop_back()
		token_grid.remove_child(token)

func add_sin(data_: SinData) -> void:
	var token = sin_scene.instantiate()
	token.data = data_
	token_grid.add_child(token)
	tokens.append(token)
	update_columns()

func add_posture(data_: PostureData) -> void:
	var token = posture_scene.instantiate()
	token.data = data_
	token_grid.add_child(token)
	tokens.append(token)
	update_columns()
	
func update_columns():
	if tokens.is_empty(): return
	token_grid.columns = 1
	
	if data.type == Bozo.Trait.FEAR or data.type == Bozo.Trait.GUILT:
		token_grid.columns = tokens.size()

func update_tooltipe_size() -> void:
	var margins = Catalog.trait_to_margin[data.type]
	var l = Catalog.TRAIT_MARGIN_OFFSET
	%TooltipMargin.add_theme_constant_override("margin_top", margins[0] * l)
	%TooltipMargin.add_theme_constant_override("margin_right", margins[1] * l)
	%TooltipMargin.add_theme_constant_override("margin_bottom", margins[2] * l)
	%TooltipMargin.add_theme_constant_override("margin_left", margins[3] * l)
#endregion

func connect_signals() -> void:
	if data == null:
		return
	if data.type_changed.is_connected(_on_type_changed):
		data.type_changed.disconnect(_on_type_changed)
		data.is_selected_changed.disconnect(_on_is_selected)
	
	data.type_changed.connect(_on_type_changed)
	data.is_selected_changed.connect(_on_is_selected)
	
	call_deferred("_sync_from_data")

func _sync_from_data() -> void:
	if data == null:
		return
	init_tokens()
	_on_is_selected()

func test_max_token_count() -> void:
	if !data.sins.is_empty():
		while tokens.size() < 3:
			add_sin(data.sins.front())
	
	if !data.postures.is_empty():
		while tokens.size() < 3:
			add_posture(data.postures.front())

func reset() -> void:
	while !tokens.is_empty():
		var token = tokens.pop_back()
		token_grid.remove_child(token)

func _on_type_changed() -> void:
	update_columns()

func _on_is_selected() -> void:
	visible = data.is_selected
