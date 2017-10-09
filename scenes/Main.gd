extends Node2D
onready var viewport = get_node("ViewportSprite/Viewport")

var current_world = "World-01"
var current_scene

func _ready():
	current_scene = load("res://scenes/Worlds/%s.tscn" % current_world)
	pass

func _on_next_world(where):
	var next = where.instance()
	var old = get_node("ViewportSprite/Viewport/%s" % current_world)
	old.set_name("DEADWORLD")
	old.queue_free()
	next.connect("next_world", self, "_on_next_world")
	next.connect("reset", self, "_on_reset")
	current_world = next.get_name()
	current_scene = where
	
	viewport.add_child(next, true)
	

func _on_reset():
	var reset = current_scene.instance()
	var old = get_node("ViewportSprite/Viewport/%s" % current_world)
	old.set_name("DEADWORLD")
	# this next line cause a crash to happen...
	# viewport.remove_child(old)
	old.queue_free()
	reset.connect("next_world", self, "_on_next_world")
	reset.connect("reset", self, "_on_reset")
	viewport.add_child(reset, true)
	