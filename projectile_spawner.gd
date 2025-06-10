extends Node2D

@export var timer : Timer
@export var projectile_scene : PackedScene

var root : Node

func _ready() -> void:
	root = get_tree().get_root()
	spawn_projectile()
	timer.timeout.connect(_on_timer_timeout)

func spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	projectile.dir = rotation
	projectile.spawn_pos = global_position
	projectile.spawn_rot = rotation
	root.add_child(projectile)

func _on_timer_timeout() -> void:
	spawn_projectile()
