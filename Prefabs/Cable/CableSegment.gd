extends Node2D

onready var tween : Tween = $DeathTween

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
func destroy():
	tween.interpolate_property($Sprite, "modulate",
		Color(1,1,1,1), Color(0,0,0,0), 4 + rng.randf_range(-2, 4),
		Tween.TRANS_SINE , Tween.EASE_OUT)
	tween.start()

func _on_DeathTween_tween_completed(object, key):
	queue_free()
