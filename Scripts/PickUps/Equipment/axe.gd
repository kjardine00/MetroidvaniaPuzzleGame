extends Node2D

@export var interact_comp : InteractComponent

func _ready() -> void:
    interact_comp.interact_action.connect(_on_interact_action)

func _on_interact_action(interactor: Player) -> void:
    print_debug("[Axe] Interacted with by: ", interactor.name)