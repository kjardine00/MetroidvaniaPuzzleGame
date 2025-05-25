extends Node
class_name StateMachine

@export var debug: bool = false

var p: Player

@export_category("Connect States")
@export var AttackState: State
@export var ClimbState: State
@export var DashState: State
@export var DieState: State
@export var FallState: State
@export var HurtState: State
@export var IdleState: State
@export var JumpState: State
@export var RunState: State
@export var WallJumpState: State
@export var WallLatchState: State

var state: State
var prev_state: State

@export_category("Jump Buffer Settings")
@export var jump_buffer_time: float = 0.1  # Time window for jump buffer in seconds
var jump_buffer_timer: float = 0.0
var jump_is_buffered: bool = false

#region Core State Machine
func _ready() -> void:
	p = get_parent() as Player

	for s in self.get_children():
		if s is State:
			s.player = p
			s.sm = self
			
	state = IdleState
	prev_state = IdleState
	if debug:
		print_debug("[StateMachine] Current State: " + state.name)

func _physics_process(_delta: float):
	check_state_transitions()
	
	#region Jump Buffer
	if jump_is_buffered:
		jump_buffer_timer -= _delta
		if jump_buffer_timer <= 0:
			jump_is_buffered = false
	#endregion

func change_state(next_state):
	if next_state:
		prev_state = state
		state = next_state
		prev_state.exit_state()
		state.enter_state()
		
		if debug: 
			print_debug("[StateMachine] Transitioning from " + prev_state.name + " to " + state.name)

## These are the static tranistions that are not reliant on input from the player
func check_state_transitions():
	match state:
		IdleState:
			# Priority: Falling > Walking
			if !p.is_on_floor():
				change_state(FallState)
			elif p.x_dir_input != 0:  # Only check horizontal input
				change_state(RunState)
		
		RunState:
			# Priority: Falling > Idle
			if !p.is_on_floor():
				change_state(FallState)
			elif p.x_dir_input == 0:  # Only check horizontal input
				change_state(IdleState)
				
		FallState:
			# Priority: Floor Landing > Wall Slide
			if p.is_on_floor():
				if jump_is_buffered:
					change_state(JumpState)
				elif p.x_dir_input == 0:
					change_state(IdleState)
				else:
					change_state(RunState)
			elif p.is_on_wall() and p.wall_detector.is_colliding():
				change_state(WallLatchState)
			elif jump_is_buffered && p.movement_handler.coyote_active:
				change_state(JumpState)

		JumpState:
			# Priority: Wall Slide > Floor Landing > Falling
			if p.is_on_wall() && p.wall_detector.is_colliding():
				change_state(WallLatchState)
			elif p.is_on_floor():
				if p.x_dir_input == 0:
					change_state(IdleState)
				else:
					change_state(RunState)
			elif p.velocity.y >= 0:  # At peak of jump or moving down
				change_state(FallState)

		WallLatchState:
			pass
			# # Priority: Floor Landing > Wall Jump > Lost Wall Contact
			# if p.is_on_floor():
			# 	if input_direction == Vector2.ZERO:
			# 		change_state(IDLING)
			# 	else:
			# 		change_state(WALKING)
			# elif !p.is_on_wall() || !p.wall_detector.is_colliding():
			# 	change_state(FALLING)

		WallJumpState:
			pass
			# # Priority: Wall Slide > Floor Landing > Falling
			# if p.is_on_wall() && p.wall_detector.is_colliding() and p.head_ability == HeadEquip.AbilityType.WALL_JUMP:
			# 	change_state(WALL_SLIDING)
			# elif p.is_on_floor():
			# 	if input_direction == Vector2.ZERO:
			# 		change_state(IDLING)
			# 	else:
			# 		change_state(WALKING)
			# elif p.velocity.y >= 0:  # At peak of wall jump or moving down
			# 	change_state(FALLING)

		DashState:
			pass
			# Priority: Floor Landing > Wall Slide > Falling | Jumping is handled in state.gd
			# if state.dash_timer <= 0:
			# 	if !p.is_on_floor():
			# 		change_state(FALLING)
			# 	elif input_direction == Vector2.ZERO:
			# 		change_state(IDLING)
			# 	else:
			# 		change_state(WALKING)
			# elif p.is_on_wall() && p.wall_detector.is_colliding() and p.head_ability == HeadEquip.AbilityType.WALL_JUMP:
			# 	change_state(WALL_SLIDING)
#endregion

var jump_pressed: bool = false
func handle_jump_input():
	jump_pressed = true
	buffer_jump()
	if p.jumps_available > 0:
		match state:
			WallLatchState:
				pass
				change_state(WallJumpState)
			_:
				
				change_state(JumpState)
		
	await get_tree().physics_frame
	jump_pressed = false

func handle_jump_released():
	match state:
		JumpState:
			if p.velocity.y < 0:
				p.movement_controller.cut_jump()
		WallJumpState:
			if p.velocity.y < 0:
				p.movement_controller.cut_jump()

# func handle_ability_input(ability_type : BodyEquip.AbilityType, direction : Vector2):
# 	match ability_type:
# 		BodyEquip.AbilityType.ROLL:
# 			if p.is_on_floor():
# 				ROLLING.last_direction = direction
# 				change_state(ROLLING)
# 		BodyEquip.AbilityType.DASH:
# 			DASHING.last_direction = direction
# 			change_state(DASHING)
#endregion

func buffer_jump():
	jump_is_buffered = true
	jump_is_buffered = true
	jump_buffer_timer = jump_buffer_time
