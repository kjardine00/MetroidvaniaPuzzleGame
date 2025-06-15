class_name Door extends Node2D

# @export var destination_room
@export var is_locked : bool = false
@export var interaction_comp : InteractComponent

func _ready() -> void:
	interaction_comp.interact_action.connect(_on_interact)
	interaction_comp.is_locked = is_locked

func _on_interact() -> void:
	if is_locked:
		print("Door is locked")
	else:
		print("Door is unlocked")
