extends RigidBody2D
class_name Drone

export(float) var speed = 5.0
export(int) var health = 100

signal dead

# How close the drone  must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 10

# Path that the drone must follow - undefined by default
var path
var target
var ennemi_proche

var stunned : bool = false 
var dead : bool = false
var last_update: float = 0
var max_speed


var rng = RandomNumberGenerator.new()

onready var navigation2D : Navigation2D = get_tree().get_root().find_node("Navigation2D", true, false)
onready var sound : AudioStreamPlayer2D = $Sound
onready var tween : Tween = $DeathTween
onready var electronics = load("res://Prefabs/Electronics/Electronics.tscn")
var dropped_electronics = false

# Called when the node enters the scene tree for the first time.
func _ready():
	max_speed = speed
	$HealthBar.health = health
	rng.randomize()
	_chooseTarget()

# Performed on each step
func _integrate_forces(_state):

	# Only do stuff if we have a current path and we are not stunned
	if path and not stunned and not ennemi_proche:

		# The next point is the first member of the path array
		var target = path[0]

		# Determine direction in which drone must move
		var direction = target - position
		direction = direction.normalized()

		apply_impulse(Vector2(0, 0), direction * speed)

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0)

			# If we have no points left, remove path
			if path.size() == 0:
				path = null

			_chooseTarget()

func _process(delta):
	if stunned:
		get_node("Line2D").clear_points()
		return
	
	trouver_ennemi_plus_proche(60)
	get_node("Line2D").clear_points()
	if ennemi_proche:	
		if ennemi_proche.has_method("methodeQuiSertARienOrdiMere"):
			var vecteurHasard = Vector2(rng.randi_range(-8,8), rng.randi_range(15,23))
			get_node("Line2D").add_point(get_node(".").to_local(ennemi_proche.get_global_position()+vecteurHasard))
		else:
			get_node("Line2D").add_point(get_node(".").to_local(ennemi_proche.get_global_position()))
		get_node("Line2D").add_point(Vector2(0, 0))
		ennemi_proche.get_node("HealthBar").damage(1)
	else:
		if last_update > 2:
			last_update = rng.randf_range(0, 1)
	
			_chooseTarget()
		
			if path:
				var imp = (position - target.position).normalized().rotated(rng.randf_range(-0.5*PI, 0.5*PI))
				apply_impulse(Vector2(0, 0), imp * speed * 10)
	
		last_update += delta

func _calculate_new_path():
	
	if target == null:
		return

	# Finds path
	var nextpath = navigation2D.get_simple_path(position, target.position)

	# If we got a path...
	if nextpath:
		
		# Remove the first point (it's where the sidekick is)
		nextpath.remove(0)
		
		# Sets the sidekick's path
		path = nextpath

func _chooseTarget():
	var plus_petite_distance
	var ordi_plus_proche
	var il_existe_des_ordi_en_vie = false
	# On itère à travers les nœuds enfants
	for i in get_node("../").get_children():
		if i.has_method("methodeQuiSertARienOrdiMere"):
			if i.health_bar.current_health > 0:
				il_existe_des_ordi_en_vie = true
				# On a trouvé une instance d'ordi mère
				if plus_petite_distance == null or self.position.distance_to(i.position) < plus_petite_distance:
					plus_petite_distance = self.position.distance_to(i.position)
					ordi_plus_proche = i
	# Si pas d'ordi => le player
	if not il_existe_des_ordi_en_vie:
		for i in get_node("../").get_children():
			if i.has_method("methodeQuiSertARienPlayer") :
				ordi_plus_proche = i
	target = ordi_plus_proche
	_calculate_new_path()

func _on_HealthBar_death():
	if dead == true:
		return
	dead = true
	$Light2D.set_energy(0)
	$StunnedTimer.stop()
	sound.play()
	tween.interpolate_property($Sprite, "scale",
		Vector2(1, 1), Vector2(0, 0), 1,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()
	emit_signal("dead", self)

func _on_DeathTween_tween_completed(object, key):
	queue_free() # RIP le drone

func _on_HealthBar_stun():
	stunned = true
	$Light2D.set_energy(0.4)
	$StunnedTimer.start()

func _on_StunnedTimer_timeout():
	$Light2D.set_energy(0.9)
	stunned = false

func _on_HealthBar_hit():
	$SlowedTimer.start()
	speed = max_speed * 0.25

func _on_SlowedTimer_timeout():
	speed = max_speed

func drop_electronics_once():
	if not dropped_electronics:
		var new_elec = electronics.instance()
		get_parent().add_child(new_elec)
		new_elec.global_position = global_position
		dropped_electronics = true


func _on_DeathTween_tween_step(object, key, elapsed, value):
	if elapsed > 0.5:
		drop_electronics_once()

func trouver_ennemi_plus_proche(rayon):
	var plus_petite_distance = rayon
	ennemi_proche = null
	var il_existe_des_ordi_en_vie = false
	# On itère à travers les nœuds enfants
	for i in get_node("../").get_children():
		if i.has_method("methodeQuiSertARienOrdiMere") :
			if i.health_bar.current_health > 0:
				il_existe_des_ordi_en_vie = true
				# On a trouvé une instance d'ennemi de drone
				if self.position.distance_to(i.position) < plus_petite_distance:
					plus_petite_distance = self.position.distance_to(i.position)
					ennemi_proche = i
	# Si pas d'ordi => le player
	if not il_existe_des_ordi_en_vie:
		for i in get_node("../").get_children():
			if i.has_method("methodeQuiSertARienPlayer") :
				if self.position.distance_to(i.position) < plus_petite_distance:
					ennemi_proche = i
	# On va peut-être retourner NULL (aucun ennemi proche)
	# et l'appelant doit le prendre en compte !

func methodeQuiSertARienDrone():
	pass
