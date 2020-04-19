extends Node2D

func _ready():
	pass # Replace with function body.

var turret

var turret_cost = 10

export(NodePath) var player_node : NodePath

onready var turret_scene = load("res://PNJ/tourelle.tscn")
onready var player = get_node(player_node)

func _input(event):
	
	if Input.is_action_just_pressed("Cancel") and turret:
		turret.cancel_building()
		turret = null
	if Input.is_action_just_pressed("Build"):
		if turret:
			if turret.can_build:
				var turret_pos = turret.global_position
				remove_child(turret)
				player.get_parent().add_child(turret)
				turret.global_position = turret_pos
				turret.accept_building()
				player.add_electronics(-turret_cost)
				turret = null
		elif player.electronics >= turret_cost:
			turret = turret_scene.instance()
			add_child(turret)
			turret.start_building()
