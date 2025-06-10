class_name Item extends Resource

## TODO: Implement these fields below
@export var name : String
@export var projectile : PackedScene
@export_enum("Linear", "Arc", "None") var type : String = "None"
@export var icon : Texture2D
@export var damage : float = 1.0
@export var cooldown : float = 0.5