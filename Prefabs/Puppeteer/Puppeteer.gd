extends Node2D

signal first_spawn
signal wave_completed
signal all_waves_completed

const DRONE_EASY = 0
const DRONE_MEDIUM = 1
const DRONE_HARD = 2

const WAVES = [
	{
		DRONE_EASY: 5
	},
	{
		DRONE_EASY: 8, DRONE_MEDIUM: 2,
	},
	{
		DRONE_EASY: 5, DRONE_MEDIUM: 10,
	},
	{
		DRONE_EASY: 5, DRONE_MEDIUM: 10, DRONE_HARD: 2,
	},
	{
		DRONE_EASY: 10, DRONE_MEDIUM: 10, DRONE_HARD: 5,
	},
]

const PARAMETERS = {
	DRONE_EASY: {
		"speed": 4, "health": 100
	},
	DRONE_MEDIUM: {
		"speed": 8, "health": 200
	},
	DRONE_HARD: {
		"speed": 12, "health": 400
	},
}

const WAVE_SPAWN_TIMER = 5

const REST_TIMER = 5

onready var enemy_prefabs = {
	DRONE_EASY: load("res://Prefabs/Drone/Drone.tscn"),
	DRONE_MEDIUM: load("res://Prefabs/Drone/Drone.tscn"),
	DRONE_HARD: load("res://Prefabs/Drone/Drone.tscn"),
}

var spawners: Array
var current_wave: Dictionary
var spawn_count: int = 0
var current_wave_num: int = 0
var alive_enemies: int = 0

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

	for child in get_parent().get_children():
		if child.has_method("methodeQuiSertARienSpawner"):
			spawners.push_back(child)
	
	connect("wave_completed", $Music, "switch_to_calm")
	connect("first_spawn", $Music, "combat")

	next_wave()

func spawn():
	if current_wave.keys().size():
		var type = get_next_enemy()
		if type != -1:
			var spawner = rng.randi_range(0, spawners.size() - 1)
			do_spawn_instance(spawners[spawner], type)
			spawn_count += 1
			if spawn_count == 1:
				emit_signal("first_spawn")
		else:
			end_of_wave()

func end_of_wave():
	current_wave.clear()
	$SpawnTimer.stop()
	
	if current_wave_num >= WAVES.size():
		emit_signal("all_waves_completed", self, WAVES.size())
		print_debug("All waves completed !")
	else:
		emit_signal("wave_completed", self, current_wave_num, WAVES.size())
		print_debug("wave " + str(current_wave_num) + "/" + str(WAVES.size()) + " completed !")
		$RestTimer.wait_time = REST_TIMER
		$RestTimer.one_shot = true
		$RestTimer.start()

func next_wave():
	current_wave_num += 1
	alive_enemies = 0
	spawn_count = 0

	if current_wave_num >= WAVES.size():
		return

	current_wave = WAVES[current_wave_num - 1]
	
	$SpawnTimer.wait_time = WAVE_SPAWN_TIMER
	$SpawnTimer.start()

func time_to_spawn():
	return true

func get_next_enemy():
	var remaining_types = current_wave.keys().size()

	if remaining_types == 0:
		return -1

	return current_wave.keys()[rng.randi_range(0, remaining_types - 1)]

func do_spawn_instance(spawner: Node2D, type: int):
	var prefab = enemy_prefabs.get(type)
	var instance = prefab.instance()

	for key in PARAMETERS.get(type).keys():
		instance.set(key, PARAMETERS.get(type).get(key))

	instance.set_position(spawner.position)
	instance.connect("dead", self, "_on_Enemy_Dead")

	get_parent().add_child(instance)
	
	alive_enemies += 1
	
	var remaining = current_wave.get(type) - 1
	if remaining == 0:
		current_wave.erase(type)
	else:
		current_wave[type] = remaining

func _on_SpawnTimer_timeout():
	spawn()

func _on_RestTimer_timeout():
	next_wave()

func _on_Enemy_Dead(enemy):
	alive_enemies -= 1

	if current_wave_num != 0 and alive_enemies <= 0 and current_wave.size() == 0:
		end_of_wave()
