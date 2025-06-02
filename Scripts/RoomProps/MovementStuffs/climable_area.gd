class_name ClimableArea extends Area2D

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body: Player) -> void:
    body.can_climb = true

func _on_body_exited(body: Player) -> void:
    body.can_climb = false