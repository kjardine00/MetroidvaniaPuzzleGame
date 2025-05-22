extends Node

enum CONTEXT {
	GAMEPLAY,
	MENU,
}

var current_context: CONTEXT = CONTEXT.GAMEPLAY

#region Gameplay Signals
signal movement_input(input_dir: Vector2)
signal jump
signal jump_released
signal interact
signal attack
#endregion

func _input(event: InputEvent) -> void:
	pass 

func _unhandled_input(event: InputEvent) -> void:
	match current_context:
		CONTEXT.GAMEPLAY:
			_handle_gameplay_input(event)
		CONTEXT.MENU:
			_handle_menu_input(event)
	
var last_dir = Vector2.ZERO

#region Gameplay Input Handling
func _handle_gameplay_input(event) -> void:
	var direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		0
	)

	if direction != last_dir:
		last_dir = direction
		movement_input.emit(direction.normalized())

	if event.is_action_pressed("jump"):
		jump.emit()

	if Input.is_action_just_released("jump"):
		jump_released.emit()

	if event.is_action_pressed("interact"):
		interact.emit()
		
	if event.is_action_pressed("attack"):
		attack.emit()

	## TODO: Add Pause, Inventory, and Charm/Item Action
#endregion
		
func _handle_menu_input(event: InputEvent) -> void:
	## TODO: Add Menu Controls
	print_debug("Menu input: ", event)

func set_context(new_context: CONTEXT) -> void:
	current_context = new_context
	print_debug("Switched to new context: ", current_context)
