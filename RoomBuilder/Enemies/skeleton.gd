extends Node2D

@export var sprite: Sprite2D
@export var hurtbox: Hurtbox
@export var fx_anim_player: AnimationPlayer

@export var stats: Stats:
	set(value):
		stats = value
		if value is not Stats: return
		stats = stats.duplicate()

@onready var shaker := Shaker.new(sprite)

func _ready() -> void:

	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
		stats.health -= other_hitbox.damage
		fx_anim_player.play("hit_flash")
		shaker.shake(2.0, 0.2)
		print_debug("[Skeleton] Health: ", stats.health)
	)
	stats.no_health.connect(func():
		queue_free()
	)
