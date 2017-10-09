extends Area2D
var active = false

func _ready():
	pass


func _on_Switch_body_enter( body ):
	if body.get_parent().get_name() != "Player":
		return
	if not active:
		active = true
		get_node("Sprite").set_frame(1)
	else:
		active = false
		get_node("Sprite").set_frame(0)
