extends Node
class_name StateMachine

@export var player: Player
@export var states: Array[State]

var previous_state: Player.STATE = Player.STATE.IDLE

func _ready() -> void:
	player = get_parent()

func _physics_process(delta: float) -> void:
	_check_tranisition_conditions()


func _check_tranisition_conditions() -> void:
	match player.state:
		Player.STATE.IDLE:
			pass
		Player.STATE.WALK:
			pass
		Player.STATE.JUMP:
			pass
		Player.STATE.FALL:
			pass