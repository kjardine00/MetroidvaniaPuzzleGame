class_name Stats extends Resource

signal no_health()

@export var health := 10.0 :
    set(value):
        health = value
        if health <= 0: no_health.emit()
