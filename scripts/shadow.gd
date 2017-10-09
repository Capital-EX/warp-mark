extends Area2D

var life = 1.0
var decay = 0
var harmful = false

func _process(delta):
	life -= decay * delta
	set_opacity(life)
	if life <= 0:
		get_parent().remove_child(self)

func _ready():
	set_process(true)


func _on_Shadow_body_enter( body ):
	var parent = body.get_parent()
	if parent.get_name() == "Player":
		if harmful:
			parent.emit_signal("reset")


func _on_Shadow_body_exit( body ):
	if body.get_parent().get_name() == "Player":
		harmful = true
