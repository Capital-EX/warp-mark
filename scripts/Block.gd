extends StaticBody2D
export (bool) var active = true


onready var sprite = get_node("Sprite")
onready var collision = get_node("CollisionShape2D")
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func toggle():
	if not active:
		collision.set_trigger(true)
		sprite.set_frame(1)
		active = true
	else:
		collision.set_trigger(false)
		sprite.set_frame(0)
		active = false

func _ready():
	if not active:
		collision.set_trigger(true)
		sprite.set_frame(1)
	pass
