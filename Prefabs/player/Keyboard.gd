extends Node2D

onready var animation : AnimationPlayer = $Animation 

var direction = true
var anim_for_dir = {true: "attack_down", false: "attack_up"}
onready var sound_player : AudioStreamPlayer = $Sounds
var sounds = []

func _ready():
	sounds.append(preload("res://Prefabs/player/key1.wav"))
	sounds.append(preload("res://Prefabs/player/key2.wav"))
	sounds.append(preload("res://Prefabs/player/key3.wav"))
	sounds.append(preload("res://Prefabs/player/key4.wav"))
	sound_player.stream = sounds.front()

func _input(event):
	if Input.is_action_just_pressed("Attack") and not animation.is_playing():	
		animation.play(anim_for_dir[direction])
		direction = not direction


func _on_HitDetection_body_entered(body: Node2D):
	for child in body.get_children():
		if child is HealthBar:
			child.damage(20)
			sound_player.play()
			sounds.shuffle()
			sound_player.stream = sounds.front()
