extends Node2D
class_name Cable

onready var player : Node2D = get_tree().get_root().find_node("Player", true, false)

var segment_prefab = load("res://Prefabs/Cable/CableSegment.tscn")

var last_position : Vector2
var previous_segment : Node2D
var pending_segment : Node2D

var target: Node2D

const THRESHOLD = 24

var building = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pending_segment = segment_prefab.instance()
	pending_segment.set_position(Vector2(0, 0))
	add_child(pending_segment)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if building:
		pending_segment.look_at(player.position)
		
		var dist_vec = player.position - (position + pending_segment.position)
		var dist = dist_vec.length()
		
		#var angle = 0
		#if previous_segment != null:
			#angle = (previous_segment.rotation - pending_segment.rotation)
		
		if dist > THRESHOLD:
			next_segment(pending_segment.position + dist_vec.normalized() * 16)

func start_cable(origin):
	position = origin
	building = true

func end_cable(end_target):
	var segment = segment_prefab.instance()
	var dist_vec = player.position - (position + pending_segment.position)
	segment.set_position(pending_segment.position + dist_vec.normalized() * 16)
	add_child(segment)
	segment.look_at(end_target.position)
	building = false
	target = end_target

func next_segment(new_position: Vector2):
	var segment = segment_prefab.instance()
	segment.set_position(new_position)
	add_child(segment)
	segment.look_at(player.position)
	previous_segment = pending_segment
	pending_segment = segment
