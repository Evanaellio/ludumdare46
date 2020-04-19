extends Node2D

var speed = 0.0
var player : Player = null
var lerp_progress = 0.0

onready var sound_player : AudioStreamPlayer = $Sounds
var sounds = []

func _ready():
	sounds.append(preload("res://Prefabs/Electronics/plop1.wav"))
	sounds.append(preload("res://Prefabs/Electronics/plop2.wav"))
	sounds.append(preload("res://Prefabs/Electronics/plop3.wav"))
	sounds.shuffle()
	sound_player.stream = sounds.front()

func _process(delta):
	if player:
		global_position = global_position.linear_interpolate(player.global_position, lerp_progress)
		scale = scale.linear_interpolate(Vector2.ZERO, lerp_progress)

func _on_Magnet_body_entered(body):
	if not player and body is Player:
		player = body
		$Tween.interpolate_property(self, "lerp_progress", 0.0, 1.0, 1,
			Tween.TRANS_EXPO, Tween.EASE_IN)
		$Tween.start()

func _on_Tween_tween_completed(object, key):
	sound_player.play()
	player.add_electronics(1)

func _on_Sounds_finished():
	queue_free()
