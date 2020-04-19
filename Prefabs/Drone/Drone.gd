extends RigidBody2D
class_name Drone

export(int) var speed = 5
export(int) var health = 100

signal dead

# How close the drone  must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 10

# Path that the drone must follow - undefined by default
var path
var target

var stunned : bool = false 
var dead : bool = false
var last_update: float = 0

var rng = RandomNumberGenerator.new()

onready var navigation2D : Navigation2D = get_tree().get_root().find_node("Navigation2D", true, false)
onready var sound : AudioStreamPlayer2D = $Sound
onready var tween : Tween = $DeathTween

# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthBar.health = health
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
	if last_update > 2:
		last_update = rng.randf_range(0, 1)

		_chooseTarget()
	
		if path and not stunned:
			var imp = (position - target.position).normalized().rotated(rng.randf_range(-0.5*PI, 0.5*PI))
			apply_impulse(Vector2(0, 0), imp * speed * 10)
	
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

func _on_HealthBar_hit():
	stunned = true
	$Light2D.set_energy(0.4)
	$StunnedTimer.start()

func _on_StunnedTimer_timeout():
	$Light2D.set_energy(0.9)
	stunned = false
