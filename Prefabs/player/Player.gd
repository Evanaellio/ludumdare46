extends KinematicBody2D
class_name Player

onready var animation : AnimationPlayer = $Animation
onready var h_axis : Node2D = $HorizontalAxis

var dir = Vector2.ZERO
var moving = false
var dir_scale = 1

export(int) var starting_electronics = 0
var electronics : int
signal update_electronics(nb_electronics)

var connectingTourelle: tourelle = null
var current_cable: Cable = null
var cable_prefab = load("res://Prefabs/Cable/Cable.tscn")

var in_range_items: Array

signal death
var dead = false

var tuto_tourelle = true
var tuto_build = true
var tuto_ordi = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_electronics(starting_electronics)
	$HealthBar.connect("death", self, "_on_death")

func _input(_event):
	if dead:
		return
	
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
	
	if Input.is_action_just_pressed("Interact"):
		useItem()

func _physics_process(_delta):
	move_and_collide(dir * 2)

func _on_UseRangeDetection_body_entered(body):
	if body.has_method("methodeQuiSertARienTourelle") or body.has_method("methodeQuiSertARienOrdiMere"):
		in_range_items.push_back(body)

func _on_UseRangeDetection_body_exited(body):
	if body.has_method("methodeQuiSertARienTourelle") or body.has_method("methodeQuiSertARienOrdiMere"):
		var id = in_range_items.find(body)
		if id > -1:
			in_range_items.remove(id)

func useItem():	
	if in_range_items.size() == 0:
		return
		
	var target = in_range_items.front()
	
	if target != null:
		if target.has_method("methodeQuiSertARienTourelle") and not target.build_mode and current_cable == null:
				current_cable = cable_prefab.instance()
				current_cable.start_cable(target.position)
				get_parent().add_child(current_cable)
				connectingTourelle = target
				tuto_ordi = tuto_tourelle
	
		if target.has_method("methodeQuiSertARienOrdiMere") and current_cable != null:
			connectingTourelle.add_cable(current_cable)
			target.link_tourelle(connectingTourelle)
			current_cable.end_cable(target)
			current_cable = null
			connectingTourelle = null
			tuto_ordi = false

		tuto_tourelle = false
		
func add_electronics(amount: int):
	electronics += amount
	emit_signal("update_electronics", electronics)

func methodeQuiSertARienPlayer():
	pass

func _on_Regen_timeout():
	if $HealthBar.current_health < $HealthBar.health:
		$HealthBar.regen(2)

func _on_death():
	if dead:
		return

	dir = Vector2.ZERO
	moving = false
	animation.play("idle")

	$RipSound.play()
	dead = true
	emit_signal("death")
