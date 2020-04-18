extends StaticBody2D
class_name ordiMere

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("2cran").play("oui",false)
	pass # Replace with function body. 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("HealthBar").health > 67:
		get_node("2cran").play("oui",false)
	elif get_node("HealthBar").health <= 67 and get_node("HealthBar").health > 33:
		get_node("2cran").play("bof",false)
	elif get_node("HealthBar").health <= 33 and get_node("HealthBar").health > 0:
		get_node("2cran").play("non",false)
	else:
		get_node("2cran").play("mort",false)
	pass
