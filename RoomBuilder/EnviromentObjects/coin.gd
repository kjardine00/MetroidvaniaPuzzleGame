class_name Coin extends CharacterBody2D

@export var collection_area: Area2D

func _ready() -> void:
	collection_area.body_entered.connect(func(_body: Player): 
		# print_debug("[Coin] coin should be collected by : " + _body.name)
		_body.inv.add_coin()
		queue_free()
	)

func _physics_process(delta: float) -> void:
	velocity.y += 250 * delta
	# TODO: Revist because I don't want to do it right now but I want the coins to bounce off the floor a small amount
	var collision = move_and_collide(velocity * delta)
	if collision != null:
		velocity = velocity.bounce(collision.get_normal())
		velocity *= 0.1 + randf_range(-0.05, 0.05)
