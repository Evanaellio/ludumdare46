extends StaticBody2D

var drone_prefab = load("res://Prefabs/Drone/Drone.tscn")

func _on_Timer_timeout():
	var drone_instance = drone_prefab.instance()
	drone_instance.set_position(position)
	get_parent().add_child(drone_instance)
