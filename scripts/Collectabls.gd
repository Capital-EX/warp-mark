extends Node2D
signal open_door
onready var fx = get_node("../SamplePlayer")
onready var child_count = get_child_count()

func _on_pickup(_):
	fx.play("pickup")
	child_count -= 1
	if child_count == 0:
		fx.play("door")
		emit_signal("open_door")
	

func _ready():
	for child in get_children():
		child.connect("body_enter", self, "_on_pickup")

