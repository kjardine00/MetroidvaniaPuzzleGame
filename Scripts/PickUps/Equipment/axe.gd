extends Node2D

@export var interact_comp : InteractComponent
@export var item_res : Item

func _ready() -> void:
    interact_comp.interact_action.connect(_on_interact_action)

func _on_interact_action(interactor: Player) -> void:
    print_debug("[Axe] Interacted with by: ", interactor.name)
    interactor.inv.active_item = item_res
    queue_free()

func _on_drop() -> void:
    push_error("[Axe] This function is not implemented")

    