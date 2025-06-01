class_name Stats extends Resource

signal no_health()

@export var max_health := 10

@export var health := 10.0 :
    set(value):
        health = value
        if health <= 0: no_health.emit()

func add_health(value: float = 1.0) -> void:
    health += value
    if health > max_health:
        health = max_health