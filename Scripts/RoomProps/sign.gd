extends Node2D

enum DIRECTION { LEFT, RIGHT }
@export var direction : DIRECTION = DIRECTION.LEFT

@export var sprite : Sprite2D
@export var interact_comp : InteractComponent
@export var sign_text : Array[String] = []

func _ready() -> void:
	match direction:
		DIRECTION.LEFT:
			sprite.region_rect.position.x = 0
		DIRECTION.RIGHT:
			sprite.region_rect.position.x = 8

	interact_comp.interact_action.connect(_on_interact_action)
	interact_comp.left_interact_area.connect(_on_left_interact_area)

func _on_interact_action(_interactor) -> void:
	print_debug("[Sign] Interacted with by: ", _interactor)
	if sign_text.size() < 1:
		push_error("[Sign] No text found in : ", self)
		return
	else:
		DialogManager.on_interact_action(sign_text, self.global_position)

func _on_left_interact_area() -> void:
	if DialogManager.active_dialog:
		DialogManager.close_dialog()
