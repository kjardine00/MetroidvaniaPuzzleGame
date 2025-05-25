extends Node2D
class_name MovementHandler

@export var p : Player

@export_category("General Properties")
## Speed in tiles per second
@export var run_speed: float = 4

@export_group("Jump Props")
@export var jump_height: float = 3
@export var max_fall_speed: float = 8
var jump_time_to_peak: float = 0.5
var jump_time_to_descent: float = 0.4
var fast_fall_factor: float = 2.0
var cut_jump_factor: float = 0.5

var coyote_time: float = 0.2
var coyote_timer: float = 0.0
var coyote_active: bool = false

@onready var move_speed: float = run_speed * Global.TILE_SIZE # Will be calculated based on run_speed

@onready var jump_velocity: float = ((2.0 * (jump_height * Global.TILE_SIZE)) / jump_time_to_peak) * -1.0

@onready var jump_gravity: float = ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * (jump_height * Global.TILE_SIZE)) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var terminal_fall_velocity: float = max_fall_speed * Global.TILE_SIZE

# @export_group("Wall Jump")
# ##How many tiles LONG can the character WALL jump
# @export var wall_jump_height : float = 1.5
# @export var wall_jump_push_distance : float = 1.5
# @export var wall_jump_time_to_peak : float = 0.5
# @export var wall_jump_time_to_descent : float = 0.4
# @export var wall_slide_gravity_multiplier : float = 0.33

# @onready var wall_jump_push_velociy : float = ((2.0 * (wall_jump_push_distance * tile_size)) / wall_jump_time_to_peak)
# @onready var wall_jump_height_velocity: float = ((2.0 * (wall_jump_height * tile_size)) / wall_jump_time_to_peak) * -1.0
# @onready var terminal_fall_velocity := max_fall_speed * tile_size

# #region Ability Settings
var pause_movement: bool = false

# @export var dash_distance: float = 3.5 #Number of tiles the p will dash
# @export var dash_duration: float = 0.4 # seconds to reach the distance of the dash
# @onready var dash_velocity: float = (dash_distance * tile_size) / dash_duration #px/s * input_direction
# #endregion

func _physics_process(delta: float) -> void:
	p.velocity.y += get_gravity() * delta
	
	# Clamp fall speed
	if p.velocity.y > terminal_fall_velocity:
		p.velocity.y = terminal_fall_velocity
	
	if p.is_on_floor():
		coyote_active = true
		coyote_timer = coyote_time
	elif coyote_active:
		coyote_timer -= delta
		if coyote_timer <= 0:
			coyote_active = false

	# Only apply input_direction-based movement when not paused
	if !pause_movement:
		
		p.velocity.x = get_horizontal_move_input() * move_speed

	p.move_and_slide()
	
func get_gravity() -> float:
	match p.state_machine.state:
		p.state_machine.FallState:
			return fall_gravity
		p.state_machine.JumpState:
			return jump_gravity
		# p.state_machine.WallJumpState:
		# 	return jump_gravity
		# p.state_machine.WallLatchState:
		# 	return wall_slide_gravity
		# p.state_machine.DashState:
		# 	return 0
		_:
			return fall_gravity

#TODO: This should me more reliant on the current state to enter a state and then change the value returned
func get_horizontal_move_input() -> float:
	match p.state_machine.state:
		p.state_machine.IdleState:
			return 0
		p.state_machine.RunState:
			return p.x_dir_input
		p.state_machine.FallState:
			return p.x_dir_input
		p.state_machine.JumpState:
			return p.x_dir_input
		_:
			return 0

## pass a value if you want to modify the jump amount from default
func jump(double_jump_modifier: float = 1):
	p.velocity.y = jump_velocity * double_jump_modifier
	p.num_of_available_jumps -= 1
	coyote_active = false  # Reset coyote time when jumping

func cut_jump():
	p.velocity.y = abs(cut_jump_factor * p.velocity.y)

func fast_fall():
	if p.velocity.y > 0:  # Only apply fast fall when falling (positive velocity)
		p.velocity.y = abs(fast_fall_factor * p.velocity.y)

# func wall_jump():
# 	if p.num_of_available_jumps > 0:
# 		p.num_of_available_jumps -= 1

# 	var wall_normal = p.get_wall_normal()
	
# 	if wall_normal.x != 0:
# 		var current_direction = input_direction.x
# 		# Set both velocity and direction for initial push
# 		p.velocity = Vector2(
# 			wall_jump_push_velociy * wall_normal.x , 
# 			wall_jump_height_velocity
# 		)
# 		input_direction = Vector2(wall_normal.x, 0)
# 		# Reset direction after a short delay to allow p control
# 		await get_tree().create_timer(0.1).timeout
# 		input_direction.x = current_direction

# func dash(last_direction : Vector2):
# 	_pause_movement_timer(dash_duration)
# 	p.velocity.x = dash_velocity * (input_direction.x if input_direction.x != 0 else last_direction.x)

# func v_corner_cutting(cutting_enabled: bool = true, correction_amount : float = 1.5):
# 	if cutting_enabled:
# 		if p.velocity.y < 0 and L_raycast.is_colliding() and !R_raycast.is_colliding() and !M_raycast.is_colliding():
# 			p.position.x += correction_amount
# 		if p.velocity.y < 0 and !L_raycast.is_colliding() and R_raycast.is_colliding() and !M_raycast.is_colliding():
# 			p.position.x -= correction_amount

func _pause_movement_timer(duration: float):
	pause_movement = true
	await get_tree().create_timer(duration).timeout
	pause_movement = false
