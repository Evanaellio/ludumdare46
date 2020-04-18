extends KinematicBody2D

onready var animation : AnimationPlayer = $Animation
onready var h_axis : Node2D = $HorizontalAxis

var dir = Vector2.ZERO
var moving = false
var dir_scale = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	dir.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if Input.is_action_just_pressed("Right"):
		h_axis.scale.x = 1
	elif Input.is_action_just_pressed("Left"):
		h_axis.scale.x = -1


	if dir != Vector2.ZERO:
		if not moving:
			moving = true
			animation.play("walk")			
	else:
		moving = false
		animation.play("idle")

func _physics_process(delta):
	move_and_collide(dir * 2)
