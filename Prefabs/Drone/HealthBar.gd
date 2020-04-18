extends Node2D
class_name HealthBar

signal death

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var health = 100

onready var bar : Node2D = $CanvasLayer/Bar
onready var progress : TextureProgress = $CanvasLayer/Bar/Position/Progress


# Called when the node enters the scene tree for the first time.
func _ready():
	progress.value = health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = get_global_transform_with_canvas().get_origin()
	bar.set_position(pos)
	
func damage(amount):
	health -= amount
	progress.value = health
	if health < amount:
		progress.hide()
		emit_signal("death")
