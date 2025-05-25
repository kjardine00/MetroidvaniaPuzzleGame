extends State

## Wall Latch State

func enter_state() -> void:
    player.reset_jumps()
    player.velocity.y = 0
