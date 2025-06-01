extends State

## Wall Jump State

func enter_state() -> void:
    player.movement_handler.wall_jump()
