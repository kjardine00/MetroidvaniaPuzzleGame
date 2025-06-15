extends Area2D

var selected_interactable: InteractComponent
var nearby_interactables: Array[InteractComponent]
var player: Player

func _ready() -> void:
	player = get_owner() as Player

	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
## The player interacts with the obj on press of the interact button
func interact(player_character: Player):
	if selected_interactable:
		selected_interactable.interaction_signal(player_character)

		if selected_interactable.remove_after_interact:
			# Temporarily store the reference
			var to_remove = selected_interactable

			# Disable interaction
			to_remove.set_deferred("monitoring", false)
			to_remove.set_deferred("monitorable", false)

			# Defer removal to avoid issues in the same frame
			await get_tree().process_frame

			# Now remove it and update selection
			nearby_interactables.erase(to_remove)
			if selected_interactable == to_remove:
				selected_interactable = null

			if nearby_interactables.size() > 0:
				selected_interactable = nearby_interactables[0]

func _on_area_entered(area: Area2D) -> void:
	if area is InteractComponent:
		nearby_interactables.push_back(area)
		area.toggle_interact_icon.emit(true)

		if selected_interactable == null:
			selected_interactable = nearby_interactables[0]

func _on_area_exited(area: Area2D) -> void:
	if area is InteractComponent:
		nearby_interactables.erase(area)
		
		if selected_interactable:
			selected_interactable.stop_interacting(player)
			selected_interactable = null
		
		if nearby_interactables.size() > 0:
			selected_interactable = nearby_interactables[0]
