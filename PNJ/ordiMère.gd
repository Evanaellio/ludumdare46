extends StaticBody2D
class_name ordiMere

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var connected_tourelles: Array
onready var health_bar = $HealthBar
onready var ecran = $"2cran"

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("2cran").play("oui",false)
	pass # Replace with function body. 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var health_percent : float = float(health_bar.current_health) / health_bar.health
	print_debug(health_percent, health_bar.current_health, health_bar.health)
	if health_percent > 0.67:
		ecran.play("oui",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(0, 1, 0)
	elif health_percent <= 0.67 and health_percent > 0.33:
		ecran.play("bof",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(1, 0.7, 0)
	elif health_percent <= 0.33 and health_percent > 0:
		ecran.play("non",false)
		$Light2D2.energy = 0.5
		$Light2D2.color = Color(1, 0, 0)
	else:
		ecran.play("mort",false)
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
