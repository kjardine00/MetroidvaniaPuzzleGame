extends Node
class_name State

var sm: StateMachine
var player : Player 

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	pass

#TODO: this should be living in the movement handler based off what state we are in
func handle_jump_input():
	if player.num_of_available_jumps > 0:
		if sm.current_state == sm.WALL_SLIDING:
			sm.change_state(sm.WallJumpState)
			# Clear both jump buffers when wall jumping
			sm.jump_is_buffered = false
			sm.wall_jump_is_buffered = false
		else:
			sm.change_state(sm.JumpState)
			# Clear the jump buffer when we successfully jump
			sm.jump_is_buffered = false