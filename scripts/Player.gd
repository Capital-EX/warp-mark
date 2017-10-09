extends Node2D
signal reset

onready var sprite	= get_node("Body/Sprite")
onready var body	= get_node("Body")
onready var shadows	= get_node("Shadows")
onready var mark	= get_node("Mark")
onready var fx 		= get_node("Fx")

const Shadow		= preload("res://scenes/Shadow.tscn")
const speed			= 150.0
const jumpf			= -325.0
const G				= 1000.0
const up			= Vector2(0, -1)
const down			= Vector2(0, 1)
const max_travel	= 32

var velocity 		= Vector2()
var travel			= Vector2()
var can_jump		= false
var can_warp		= false
var warp_released	= true	# This is annoying to have to do...
var is_shadow		= false
var shadow_released = true

func _fixed_process(delta):
	if Input.is_action_pressed("reset"):
		emit_signal("reset")
		return
		
	velocity.y = min(G, velocity.y + G * delta)
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		sprite.set_flip_h(true)
		if sprite.get_animation() != "run" or sprite.get_animation() != "shadow-run":
			if not is_shadow:
				sprite.play("run")
			else:
				sprite.play("shadow-run")
		

	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed
		sprite.set_flip_h(false)
		if sprite.get_animation() != "run" or sprite.get_animation() != "shadow-run":
			if not is_shadow:
				sprite.play("run")
			else:
				sprite.play("shadow-run")

	else:
		velocity.x = 0
		if not is_shadow:
			sprite.play("idle")
		else:
			sprite.play("shadow-idle")
	
	if Input.is_action_pressed("jump") and can_jump:
		velocity.y = jumpf
		can_jump = false
		fx.play("jump")
	
	if Input.is_action_pressed("warp"):
		if warp_released and not is_shadow:
			warp_released = false
			if not can_warp:
				mark.set_pos(body.get_pos())
				mark.set_hidden(false)
				can_warp = true
			else:
				body.set_pos(mark.get_pos())
				mark.set_hidden(true)
				can_warp = false
	else:
		warp_released = true

	if Input.is_action_pressed("shadow"):
		if shadow_released:
			shadow_released = false
			if not is_shadow:
				body.set_layer_mask(1)
				body.set_collision_mask(1)
				is_shadow = true
			else:
				body.set_layer_mask(3)
				body.set_collision_mask(3)
				is_shadow = false
	else:
		shadow_released = true
	
	var motion = velocity * delta
	travel += motion
	motion = body.move(motion)
	travel -= motion

	if body.is_colliding():
		var normal = body.get_collision_normal()
		if normal == up:
			velocity.y = 0
			can_jump = true
		elif normal == down:
			velocity.y = 0
		
		motion = normal.slide(motion)
		travel += motion
		body.move(motion)
	
	if travel.length() > max_travel and is_shadow:
		spawn_shadow()
	elif not is_shadow:
		travel.x = 0
		travel.y = 0


func spawn_shadow():
	travel = Vector2()
	var shadow = Shadow.instance()
	var shadow_sprite = shadow.get_node("Sprite")
	shadow.set_pos(body.get_pos())
	shadow_sprite.set_flip_h(sprite.is_flipped_h())
	shadow_sprite.set_frame(sprite.get_frame())
	shadows.add_child(shadow)

func _ready():
	set_fixed_process(true)
