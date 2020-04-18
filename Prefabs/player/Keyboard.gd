extends Node2D

onready var animation : AnimationPlayer = $Animation 

var direction = true
var anim_for_dir = {true: "attack_down", false: "attack_up"}


func _input(event):
	if Input.is_action_just_pressed("Attack") and not animation.is_playing():	
		animation.play(anim_for_dir[direction])
		direction = not direction
