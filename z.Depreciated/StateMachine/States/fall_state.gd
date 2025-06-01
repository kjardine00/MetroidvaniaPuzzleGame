extends State

## Fall State

func update(delta) -> void:
    super(delta)
    ##TODO Check for fast fall input

func handle_jump_released() -> void:
    player.movement_handler.cut_jump()