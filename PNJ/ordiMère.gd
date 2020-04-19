extends StaticBody2D
class_name ordiMere

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var connected_tourelles: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("2cran").play("oui",false)
	pass # Replace with function body. 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_node("HealthBar").health > 67:
		get_node("2cran").play("oui",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(0, 1, 0)
	elif get_node("HealthBar").health <= 67 and get_node("HealthBar").health > 33:
		get_node("2cran").play("bof",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(1, 0.7, 0)
	elif get_node("HealthBar").health <= 33 and get_node("HealthBar").health > 0:
		get_node("2cran").play("non",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(1, 0, 0)
	else:
		get_node("2cran").play("mort",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(0, 0, 1)
		for t in connected_tourelles:
			unlink_tourelle(t)
			t.destroy_cables_to(self)
	pass

func link_tourelle(t):
	connected_tourelles.push_back(t)

func unlink_tourelle(t):
	var id = connected_tourelles.find(t)
	if id > -1:
		connected_tourelles.remove(id)

func methodeQuiSertARienOrdiMere():
	pass
