extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass


func _on_Switch_body_enter( body ):
	for child in get_children():
		child.toggle()