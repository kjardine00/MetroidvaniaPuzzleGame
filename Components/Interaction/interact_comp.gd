class_name InteractComponent extends Area2D

signal interact_action
signal left_interact_area
signal entered_interact_area

@export var interact_icon : AnimatedSprite2D
@export var interact_once := false

var is_locked := false

func _ready() -> void:
	interact_icon.visible = false

func interact(actor: Player) -> void:
	interact_action.emit(actor)
	interact_icon.visible = false
	interact_icon.stop()

func stop_interacting(actor: Player) -> void:
	left_interact_area.emit(actor)
	interact_icon.visible = false
	interact_icon.stop()

func interact_area_entered() -> void:
	interact_icon.visible = true
	if is_locked:
		interact_icon.play("locked")
	else:
		interact_icon.play("default")
	entered_interact_area.emit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_input"):
		interact_action.emit("DEBUG")
