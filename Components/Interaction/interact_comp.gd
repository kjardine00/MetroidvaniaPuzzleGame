class_name InteractComponent extends Area2D

signal interact_action
signal left_interact_area

@export var interact_once : bool = false

func interact(actor: Player) -> void:
    interact_action.emit(actor)

func stop_interacting(actor: Player) -> void:
    left_interact_area.emit(actor)