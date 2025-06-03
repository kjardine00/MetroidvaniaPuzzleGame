extends Node2D

@export var anim_player : AnimationPlayer
@export var interact_comp : InteractComponent
@export var contents : Array[PackedScene]

func _ready() -> void:
	anim_player.play("chest_closed")
	interact_comp.interact_action.connect(_on_interact_action)
	interact_comp.interact_once = true

func _on_interact_action(interactor: Player) -> void:
	anim_player.play("chest_open")
	spawn_contents()
	#REVISIT: This might need to change if I want to have the chest respawn.
	interact_comp.queue_free()

func spawn_contents() -> void:
	print_debug("[Chest] Spawning contents")
	for content in contents:
		var instance = content.instantiate()
		instance.global_position = global_position
		get_parent().add_child(instance)
