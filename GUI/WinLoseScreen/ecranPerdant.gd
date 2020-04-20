extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var activation = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Sprite.modulate.a = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if activation == 1:
		$Control/Sprite.modulate.a = clamp($Control/Sprite.modulate.a + 0.005, 0, 1)
	pass


func _on_Player_death():
	activation = 1
	pass # Replace with function body.
