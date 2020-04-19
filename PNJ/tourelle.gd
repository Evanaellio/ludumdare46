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

var cables: Array

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
		elif sin(angle) < sin(-PI/8):
			get_node("Base/Fusil").set_texture(texture9)
		else:
			get_node("Base/Fusil").set_texture(texture6)
	elif cos(angle) < cos(5*PI/8):
		if sin(angle) > sin(PI/8):
			get_node("Base/Fusil").set_texture(texture1)
		elif sin(angle) < sin(-PI/8):
			get_node("Base/Fusil").set_texture(texture7)
		else:
			get_node("Base/Fusil").set_texture(texture4)
	else:
		if sin(angle) > 0:
			get_node("Base/Fusil").set_texture(texture2)
		else:
			get_node("Base/Fusil").set_texture(texture8)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drone_proche = trouver_ennemi_plus_proche()
	if drone_proche != null:
		set_angle(drone_proche.get_global_position().angle_to_point(get_node("Base/Fusil").get_global_position()))
	else:
		set_angle(-PI/2)
	pass

func trouver_ennemi_plus_proche():
	var plus_petite_distance
	var drone_plus_proche
	# On itère à travers les nœuds enfants
	for i in get_node("../").get_children():
		if i is Drone:
			# On a trouvé une instance de Drone
			if plus_petite_distance == null or self.position.distance_squared_to(i.position) < plus_petite_distance:
				plus_petite_distance = self.position.distance_squared_to(i.position)
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
			cable.queue_free()
			cables.remove(cables.find(cable))
