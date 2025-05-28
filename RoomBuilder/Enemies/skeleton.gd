extends Node2D

const PARTICLE_BURST_EFFECT: PackedScene = preload("res://splatter_particle_burst.tscn")

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
		var spark_particle = PARTICLE_BURST_EFFECT.instantiate()
		get_tree().current_scene.add_child(spark_particle)
		spark_particle.global_position = sprite.global_position
		stats.health -= other_hitbox.damage
		fx_anim_player.play("hit_flash")
		shaker.shake(2.0, 0.2)
		print_debug("[Skeleton] Health: ", stats.health)
	)
	stats.no_health.connect(func():
		queue_free()
	)
