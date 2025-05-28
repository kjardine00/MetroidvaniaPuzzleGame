extends Node2D

@export var hurtbox: Hurtbox

func _ready() -> void:
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		print_debug("[Skeleton] Hurt by ", other_hitbox)
	)
