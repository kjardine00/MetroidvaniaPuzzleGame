extends State

## Jump state

func enter_state() -> void:
    player.movement_handler.jump()