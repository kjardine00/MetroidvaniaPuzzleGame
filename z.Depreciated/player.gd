extends CharacterBody2D

@export_category("Connections")
@export var anim_player: AnimationPlayer
@export var movement_handler: MovementHandler
@export var state_machine: StateMachine

@export var sprite: Sprite2D
@export var wall_detector: RayCast2D

@export_category("Properties")
@export var max_jumps: int = 1

var state: State

var x_dir_input: float = 0
var jumps_available: int = 1


# @export var interact_area: 
func _ready() -> void:
	reset_jumps()
	InputHandler.movement_input.connect(_on_movement_input)
	InputHandler.jump.connect(_on_jump)
	InputHandler.jump_released.connect(_on_jump_released)
	InputHandler.interact.connect(_on_interact)
	InputHandler.attack.connect(_on_attack)

#region Handle Inputs
func _on_movement_input(input_dir: Vector2) -> void:
	x_dir_input = input_dir.x
	## Movement Handler is checking the x_dir_input to determine x_movement
	## StateMachine is checking the x_dir_input to determine state

	wall_detector.target_position.x = x_dir_input * 4
	sprite.flip_h = x_dir_input < 0

func _on_jump() -> void:
	state_machine.jump_pressed()
	#StateMachine -> JumpState.Enter() -> MovementHandler.jump()

func _on_jump_released() -> void:
	state_machine.jump_released()
	#StateMachine -> Match JumpState -> MovementHandler.cut_jump()

func _on_attack() -> void:
	#state_machine.attack()
	pass

func _on_interact() -> void:
	pass
#endregion

func reset_jumps() -> void:
	jumps_available = max_jumps
