class_name Switch extends Node2D

##TODO add the signal emission and have them setup to trigger puzzles in the room the switch is in
signal switch_L
signal switch_R
signal switch_M

@export var sprite: Sprite2D
@export var interact_comp: InteractComponent

enum STATE { LEFT, RIGHT, MIDDLE }

var prev_state: STATE
@export var state: STATE:
	set(value):
		state = value
		print_debug("[Switch] State: ", STATE.keys()[state])
		update_sprite()

func _ready() -> void:
	state = STATE.LEFT
	prev_state = state
	interact_comp.interact_action.connect(_on_interact_action)
	# interact_comp.left_interact_area.connect(interact_switch)

func update_sprite() -> void: 
	match state: 
		STATE.LEFT:
			sprite.region_rect.position.x = 0
		STATE.MIDDLE:
			sprite.region_rect.position.x = 8
		STATE.RIGHT:
			sprite.region_rect.position.x = 16

func _on_interact_action(_actor: Player) -> void:
	match state: 
		STATE.LEFT:
			prev_state = STATE.LEFT
			state = STATE.MIDDLE
		STATE.RIGHT:
			prev_state = STATE.RIGHT
			state = STATE.MIDDLE
		STATE.MIDDLE:
			if prev_state == STATE.LEFT:
				state = STATE.RIGHT
			elif prev_state == STATE.RIGHT:
				state = STATE.LEFT
			prev_state = STATE.MIDDLE

	
