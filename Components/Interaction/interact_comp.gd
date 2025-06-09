class_name InteractComponent extends Area2D

signal interact_action
signal left_interact_area

@export var interact_once : bool = false

func interact(actor: Player) -> void:
    interact_action.emit(actor)

func stop_interacting(actor: Player) -> void:
    left_interact_area.emit(actor)

func _process(delta: float) -> void:
    if Input.is_action_just_pressed("debug_input"):
        interact_action.emit("DEBUG")