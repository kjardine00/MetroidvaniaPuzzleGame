extends CharacterBody2D
class_name Player

enum STATE { MOVE, CLIMB }

@export_category("Connections")
@export var anim_player: AnimationPlayer
@export var movement_controller: MovementController

var x_dir_input: float = 0
var jumps_available: int = 1
var max_jumps: int = 1

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

func _on_jump() -> void:
	movement_controller.jump()

func _on_jump_released() -> void:
	movement_controller.jump_released()

func _on_interact() -> void:
	pass

func _on_attack() -> void:
	pass

#endregion

func reset_jumps() -> void:
	jumps_available = max_jumps
