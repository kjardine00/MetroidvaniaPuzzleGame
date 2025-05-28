class_name Shaker extends RefCounted

var target: Node2D
var start_pos: Vector2
var shakes := 4

func _init(new_target: Node2D) -> void:
	target = new_target
	start_pos = target.position

func shake(shake_amount: float, duration: float) -> void:
	for i in shakes:
		target.position = start_pos + Vector2(
			randi_range(-shake_amount, shake_amount),
			randi_range(-shake_amount, shake_amount)
		)
		await target.get_tree().create_timer(duration / shakes).timeout
		shake_amount -= (shake_amount / shakes)

	target.position = start_pos
