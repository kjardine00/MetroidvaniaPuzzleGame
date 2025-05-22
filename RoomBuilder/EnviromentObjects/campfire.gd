extends Node2D

@export var interact_component: InteractComponent

func _ready() -> void:
	interact_component.interact.connect(_on_interact)

func _on_interact(interactor: Player) -> void:
	print_debug(interactor, ": Interacted with campfire")
