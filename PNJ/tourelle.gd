extends Node2D
class_name tourelle

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var texture1
var texture2
var texture3
var texture4
var texture6
var texture7
var texture8
var texture9

var boutDeCanon = Vector2(0, -1)

var cables: Array
var diviseurTrame = 1
var compteur = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	texture1 = preload("res://Assets/Images/tourelle-1.png")
	texture2 = preload("res://Assets/Images/tourelle-2.png")
	texture3 = preload("res://Assets/Images/tourelle-3.png")
	texture4 = preload("res://Assets/Images/tourelle-4.png")
	texture6 = preload("res://Assets/Images/tourelle-6.png")
	texture7 = preload("res://Assets/Images/tourelle-7.png")
	texture8 = preload("res://Assets/Images/tourelle-8.png")
	texture9 = preload("res://Assets/Images/tourelle-9.png")
	get_node("Base/Fusil").set_texture(texture2)
	pass # Replace with function body.

func set_angle(angle):
	if cos(angle) > cos(3*PI/8):
		if sin(angle) > sin(PI/8):
			get_node("Base/Fusil").set_texture(texture3)
			boutDeCanon[0] = 10
			boutDeCanon[1] = -3
		elif sin(angle) < sin(-PI/8):
			get_node("Base/Fusil").set_texture(texture9)
			boutDeCanon[0] = 9
			boutDeCanon[1] = -13
		else:
			get_node("Base/Fusil").set_texture(texture6)
			boutDeCanon[0] = 12
			boutDeCanon[1] = -10
	elif cos(angle) < cos(5*PI/8):
		if sin(angle) > sin(PI/8):
			get_node("Base/Fusil").set_texture(texture1)
			boutDeCanon[0] = -10
			boutDeCanon[1] = -3
		elif sin(angle) < sin(-PI/8):
			get_node("Base/Fusil").set_texture(texture7)
			boutDeCanon[0] = -9
			boutDeCanon[1] = -13
		else:
			get_node("Base/Fusil").set_texture(texture4)
			boutDeCanon[0] = -12
			boutDeCanon[1] = -10
	else:
		if sin(angle) > 0:
			get_node("Base/Fusil").set_texture(texture2)
			boutDeCanon[0] = 0
			boutDeCanon[1] = -1
		else:
			get_node("Base/Fusil").set_texture(texture8)
			boutDeCanon[0] = 0
			boutDeCanon[1] = -15

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not find_connected_ordis().empty():
		var drone_proche = trouver_ennemi_plus_proche(64)
		if drone_proche != null:
			set_angle(drone_proche.get_global_position().angle_to_point(get_node("Base/Fusil").get_global_position()))
			get_node("Line2D").clear_points()
			get_node("Line2D").add_point(get_node(".").to_local(drone_proche.get_global_position()))
			get_node("Line2D").add_point(boutDeCanon)
			if compteur == diviseurTrame:
				drone_proche.get_node("HealthBar").damage(1)
		else:
			set_angle(PI/2)
			get_node("Line2D").clear_points()
		$Light2D2.energy = 0.8
	else:
		set_angle(PI/2)
		get_node("Line2D").clear_points()
		$Light2D2.energy = 0.3
		
	if compteur == diviseurTrame:
		compteur = 1
	else:
		compteur = compteur + 1
	pass

func trouver_ennemi_plus_proche(rayon):
	var plus_petite_distance = rayon
	var drone_plus_proche
	# On itère à travers les nœuds enfants
	for i in get_node("../").get_children():
		if i.has_method("methodeQuiSertARienDrone"):
			# On a trouvé une instance de Drone
			if self.position.distance_to(i.position) < plus_petite_distance:
				plus_petite_distance = self.position.distance_to(i.position)
				drone_plus_proche = i
	# On va peut-être retourner NULL (aucune drone proche)
	# et l'appelant doit le prendre en compte !
	return drone_plus_proche

func add_cable(cable: Cable):
	cables.push_back(cable)

func find_connected_ordis():
	var ordis: Array
	for cable in cables:
		var target: ordiMere = cable.target
		if ordis.find(target) == -1:
			ordis.push_back(target)
	return ordis

func destroy_cables_to(ordi: ordiMere):
	for cable in cables:
		if cable.target == ordi:
			cable.destroy()
			cables.remove(cables.find(cable))

func methodeQuiSertARienTourelle():
	pass
