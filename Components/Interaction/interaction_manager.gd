class_name InteractionManager extends Area2D

var player : Player
var current_interactable : InteractComponent
var nearby_interactables : Array[InteractComponent]

func _ready() -> void:
    player = get_owner() as Player
    area_entered.connect(_on_area_entered)
    area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
    print_debug("[InteractionManager] Area entered: ", area.name)
    if area is InteractComponent:
        nearby_interactables.push_back(area)
        if current_interactable == null:
            current_interactable = nearby_interactables[0]

func _on_area_exited(area: Area2D) -> void:
    if area is InteractComponent:
        nearby_interactables.erase(area)
        
        if current_interactable:
            current_interactable.stop_interacting(player)
            current_interactable = null
        
        if nearby_interactables.size() > 0:
            current_interactable = nearby_interactables[0]

func interact(actor: Player) -> void:
    if current_interactable:
        current_interactable.interact(actor)
        if current_interactable.interact_once:
            nearby_interactables.erase(current_interactable)
