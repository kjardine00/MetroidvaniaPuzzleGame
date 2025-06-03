extends Node2D

enum DIRECTION { LEFT, RIGHT }
@export var direction : DIRECTION = DIRECTION.LEFT

@export var sprite : Sprite2D
@export var interact_comp : InteractComponent

func _ready() -> void:
    match direction:
        DIRECTION.LEFT:
            sprite.region_rect.position.x = 0
        DIRECTION.RIGHT:
            sprite.region_rect.position.x = 8

    interact_comp.interact_action.connect(_on_interact_action)

func _on_interact_action(interactor: Player) -> void:
    print_debug("[Sign] Interacted with by: ", interactor.name)
