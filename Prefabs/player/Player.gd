extends KinematicBody2D
class_name Player

onready var animation : AnimationPlayer = $Animation
onready var h_axis : Node2D = $HorizontalAxis

var dir = Vector2.ZERO
var moving = false
var dir_scale = 1

var connectingTourelle: tourelle = null
var current_cable: Cable = null
var cable_prefab = load("res://Prefabs/Cable/Cable.tscn")

var in_range_items: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	dir.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	dir.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	if Input.is_action_just_pressed("Right"):
		h_axis.scale.x = 1
	elif Input.is_action_just_pressed("Left"):
		h_axis.scale.x = -1


	if dir != Vector2.ZERO:
		if not moving:
			moving = true
			animation.play("walk")			
	else:
		moving = false
		animation.play("idle")
	
	if Input.is_action_just_pressed("Use"):
		useItem()

func _physics_process(delta):
	move_and_collide(dir * 2)

func _on_UseRangeDetection_body_entered(body):
	if body is tourelle or body is ordiMere:
		in_range_items.push_back(body)

func _on_UseRangeDetection_body_exited(body):
	if body is tourelle or body is ordiMere:
		var id = in_range_items.find(body)
		if id > -1:
			in_range_items.remove(id)

func useItem():	
	if in_range_items.size() == 0:
		pass
		
	var target = in_range_items.front()
	
	if target is tourelle and current_cable == null:
			current_cable = cable_prefab.instance()
			current_cable.start_cable(target.position)
			get_parent().add_child(current_cable)
			connectingTourelle = target

	if target is ordiMere and current_cable != null:
		connectingTourelle.add_cable(current_cable)
		target.link_tourelle(connectingTourelle)
		current_cable.end_cable(target)
		current_cable = null
		connectingTourelle = null

func methodeQuiSertARienPlayer():
	pass
