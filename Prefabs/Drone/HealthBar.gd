extends Node2D
class_name HealthBar

signal death
signal hit

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var health = 100
var current_health

onready var bar : Node2D = $CanvasLayer/Bar
onready var progress : TextureProgress = $CanvasLayer/Bar/Position/Progress


# Called when the node enters the scene tree for the first time.
func _ready():
	current_health = health
	progress.max_value = health
	progress.value = current_health
	progress.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var pos = get_global_transform_with_canvas().get_origin()
	bar.set_position(pos)
	
func damage(amount):
	current_health -= amount
	progress.value = current_health
	emit_signal("hit")
	
	if current_health < health:
		progress.show()
	
	if current_health <= 0:
		progress.hide()
		emit_signal("death")

func regen(amount):
	current_health += amount
	progress.value = current_health
	
	if current_health < health:
		progress.show()
	
	if current_health == health:
		progress.hide()
