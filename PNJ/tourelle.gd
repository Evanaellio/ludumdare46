extends StaticBody2D
class_name tourelle

var boutDeCanon = Vector2(0, -1)

var cables: Array
var diviseurTrame = 1
var compteur = 1
var build_mode = false
var can_build = false

onready var gun = $Base/Fusil

var color_ok = Color(0, 1, 0, 0.8)
var color_ko = Color(1, 0, 0, 0.8)


func set_angle(angle):
	if cos(angle) > cos(3*PI/8):
		if sin(angle) > sin(PI/8):
			gun.frame = 7
			boutDeCanon[0] = 10
			boutDeCanon[1] = -3
		elif sin(angle) < sin(-PI/8):
			gun.frame = 5
			boutDeCanon[0] = 9
			boutDeCanon[1] = -13
		else:
			gun.frame = 6
			boutDeCanon[0] = 12
			boutDeCanon[1] = -10
	elif cos(angle) < cos(5*PI/8):
		if sin(angle) > sin(PI/8):
			gun.frame = 1
			boutDeCanon[0] = -10
			boutDeCanon[1] = -3
		elif sin(angle) < sin(-PI/8):
			gun.frame = 3
			boutDeCanon[0] = -9
			boutDeCanon[1] = -13
		else:
			gun.frame = 2
			boutDeCanon[0] = -12
			boutDeCanon[1] = -10
	else:
		if sin(angle) > 0:
			gun.frame = 0
			boutDeCanon[0] = 0
			boutDeCanon[1] = -1
		else:
			gun.frame = 4
			boutDeCanon[0] = 0
			boutDeCanon[1] = -15

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var is_connected = not find_connected_ordis().empty()
	$Light.energy = 0.8 if is_connected else 0.3
	
	if build_mode:
		can_build = $PlacementDetector.get_overlapping_bodies().empty()
		$Base.modulate = color_ok if can_build else color_ko	
	elif is_connected:
		var drone_proche = trouver_ennemi_plus_proche(64)
		if drone_proche != null:
			$Animation.stop()
			set_angle(drone_proche.get_global_position().angle_to_point(get_node("Base/Fusil").get_global_position()))
			get_node("Line2D").clear_points()
			get_node("Line2D").add_point(get_node(".").to_local(drone_proche.get_global_position()))
			get_node("Line2D").add_point(boutDeCanon)
			if compteur == diviseurTrame:
				drone_proche.get_node("HealthBar").damage(1)
		else:
			$Animation.play("idle")
			get_node("Line2D").clear_points()
	else:
		$Animation.stop()
		set_angle(PI/2)
		get_node("Line2D").clear_points()
		
	if compteur == diviseurTrame:
		compteur = 1
	else:
		compteur = compteur + 1
		
	var pos = get_global_transform_with_canvas().get_origin()
	$CanvasLayer/Node2D.set_position(pos)
	$CanvasLayer/Node2D.visible = not is_connected

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

func start_building():
	build_mode = true
	$Base/Fusil.hide()
	$CollisionPolygon2D.disabled = true

func accept_building():
	$Base/Fusil.show()
	$CollisionPolygon2D.disabled = false
	$Base.modulate = Color(1, 1, 1, 1)
	build_mode = false
	
func cancel_building():
	queue_free()
