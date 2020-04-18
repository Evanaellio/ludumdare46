extends RigidBody2D

# Speed at which the drone  will move
const MOVEMENT_SPEED = 50

# How close the drone  must be to a point in the
# path before moving on to the next one
const POINT_RADIUS = 10

# Path that the drone must follow - undefined by default
var path
var target

onready var navigation2D = get_tree().get_root().find_node("Navigation2D", true, false)
onready var sound : AudioStreamPlayer2D = $Sound
onready var tween : Tween = $DeathTween


# Called when the node enters the scene tree for the first time.
func _ready():
	chooseTarget()
	_calculate_new_path()


# Performed on each step
func _process(_delta):

	# Only do stuff if we have a current path
	if path:

		# The next point is the first member of the path array
		var target = path[0]

		# Determine direction in which drone must move
		var direction = target - position
		direction = direction.normalized()

		set_linear_velocity(direction  * MOVEMENT_SPEED)

		# If we have reached the point...
		if position.distance_to(target) < POINT_RADIUS:

			# Remove first path point
			path.remove(0)

			# If we have no points left, remove path
			if path.size() == 0:
				path = null

			chooseTarget()
			_calculate_new_path()

func _calculate_new_path():
	
	if target == null:
		pass

	# Finds path
	var nextpath = navigation2D.get_simple_path (position, target.position)

	# If we got a path...
	if nextpath:
		
		# Remove the first point (it's where the sidekick is)
		nextpath.remove(0)
		
		# Sets the sidekick's path
		path = nextpath

func chooseTarget():
	target = get_tree().get_root().find_node("Player", true, false)

func _on_HealthBar_death():
	sound.play()
	tween.interpolate_property($Sprite, "scale",
		Vector2(1, 1), Vector2(0, 0), 1,
		Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func _on_DeathTween_tween_completed(object, key):
	queue_free() # RIP le drone
