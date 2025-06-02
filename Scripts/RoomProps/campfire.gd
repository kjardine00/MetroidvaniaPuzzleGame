extends Node2D

signal lit_campfire

## TODO create an effect for the campfire being lit
## TODO: Need to create a campfire manager that handles all the campfires and only lets one be lit at a time
## TODO: Some sort of save system for the game that triggers when lighting a campfire

enum STATE { UNLIT, LIT, BURNING }
@export var state: STATE :
	set(value):
		state = value
		# print_debug("[Campfire] State: ", STATE.keys()[state])
		update_animation()

@export var interact_comp: InteractComponent
@export var anim_player: AnimationPlayer

func _ready() -> void:
	state = STATE.UNLIT

	interact_comp.interact_action.connect(_on_interact_action)

func _on_interact_action(interactor: Player) -> void:
	print_debug(interactor, ": Interacted with campfire")
	if state == STATE.UNLIT:
		state = STATE.LIT
		lit_campfire.emit()

func update_animation() -> void:
	match state:
		STATE.UNLIT:
			anim_player.play("unlit")
		STATE.LIT:
			anim_player.play("lit")
		STATE.BURNING:
			anim_player.play("burning")
