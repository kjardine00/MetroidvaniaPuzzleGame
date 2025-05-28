class_name Hitbox extends Area2D

@export var damage := 1.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	assert(area is Hurtbox, "[Hitbox] Area detected is not a Hurtbox")
	var hurtbox = area as Hurtbox

	if hurtbox.is_invincible: return
	
	hurtbox.hurt.emit(self)
