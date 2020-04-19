extends RigidBody2D
class_name Drone

# Speed at which the drone  will move
const MOVEMENT_SPEED = 5

# How close the drone  must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 10

# Path that the drone must follow - undefined by default
var path
var target

var stunned : bool = false 
var last_update: float = 0

var rng = RandomNumberGenerator.new()

onready var navigation2D : Navigation2D = get_tree().get_root().find_node("Navigation2D", true, false)
onready var sound : AudioStreamPlayer2D = $Sound
onready var tween : Tween = $DeathTween

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_chooseTarget()

# Performed on each step
func _integrate_forces(_state):

	# Only do stuff if we have a current path and we are not stunned
	if path and not stunned:

		# The next point is the first member of the path array
		var target = path[0]

		# Determine direction in which drone must move
		var direction = target - position
		direction = direction.normalized()

		apply_impulse(Vector2(0, 0), direction  * MOVEMENT_SPEED)

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0)

			# If we have no points left, remove path
			if path.size() == 0:
				path = null

			_chooseTarget()

func _process(delta):
	if last_update > 2:
		last_update = rng.randf_range(0, 1)

		_chooseTarget()
	
		if path and not stunned:
			var imp = (position - target.position).normalized().rotated(rng.randf_range(-0.5*PI, 0.5*PI))
			apply_impulse(Vector2(0, 0), imp * MOVEMENT_SPEED * 10)
	
	var ennemi_proche = trouver_ennemi_plus_proche(48)
	get_node("Line2D").clear_points()
	if ennemi_proche != null:
		get_node("Line2D").add_point(get_node(".").to_local(ennemi_proche.get_global_position()))
		get_node("Line2D").add_point(Vector2(0, 0))
		ennemi_proche.get_node("HealthBar").damage(1)
	
	last_update += delta

func _calculate_new_path():
	
	if target == null:
		pass

	# Finds path
	var nextpath = navigation2D.get_simple_path(position, target.position)

	# If we got a path...
	if nextpath:
		
		# Remove the first point (it's where the sidekick is)
		nextpath.remove(0)
		
		# Sets the sidekick's path
		path = nextpath

func _chooseTarget():
	target = get_tree().get_root().find_node("Player", true, false)
	_calculate_new_path()

func _on_HealthBar_death():
	$Light2D.set_energy(0)
	$StunnedTimer.stop()
	sound.play()
	tween.interpolate_property($Sprite, "scale",
		Vector2(1, 1), Vector2(0, 0), 1,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func _on_DeathTween_tween_completed(object, key):
	queue_free() # RIP le drone

func _on_HealthBar_hit():
	stunned = true
	$Light2D.set_energy(0.4)
	$StunnedTimer.start()

func _on_StunnedTimer_timeout():
	$Light2D.set_energy(0.9)
	stunned = false

func trouver_ennemi_plus_proche(rayon):
	var plus_petite_distance = rayon
	var ennemi_plus_proche
	# On itère à travers les nœuds enfants
	for i in get_node("../").get_children():
		if i.has_method("methodeQuiSertARienOrdiMere") :
			# On a trouvé une instance d'ennemi de drone
			if self.position.distance_to(i.position) < plus_petite_distance:
				plus_petite_distance = self.position.distance_to(i.position)
				ennemi_plus_proche = i
	# On va peut-être retourner NULL (aucun ennemi proche)
	# et l'appelant doit le prendre en compte !
	return ennemi_plus_proche

func methodeQuiSertARienDrone():
	pass
