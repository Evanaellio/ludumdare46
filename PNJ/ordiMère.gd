extends StaticBody2D
class_name ordiMere

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var connected_tourelles: Array
onready var health_bar = $HealthBar
onready var ecran = $"2cran"
onready var player = get_tree().get_root().find_node("Player", true, false)

var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("2cran").play("oui",false)
	pass # Replace with function body. 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var health_percent : float = float(health_bar.current_health) / health_bar.health

	if health_percent > 0.67:
		ecran.play("oui",false)
		$Light2D2.energy = 0.6
		$Light2D2.color = Color(0, 1, 0)
		$Light2D3.color = Color(0, 1, 0)
	elif health_percent <= 0.67 and health_percent > 0.33:
		ecran.play("bof",false)
		$Light2D2.energy = 0.6
		$Light2D2.color = Color(1, 0.7, 0)
		$Light2D3.color = Color(1, 0.7, 0)
	elif health_percent <= 0.33 and health_percent > 0:
		ecran.play("non",false)
		$Light2D2.energy = 0.6
		$Light2D2.color = Color(1, 0, 0)
		$Light2D3.color = Color(1, 0, 0)
	else:
		ecran.play("mort",false)
		dead()
		$Light2D2.energy = 0.5
		$Light2D3.energy = 0.5
		$Light2D2.color = Color(0, 0, 1)
		$Light2D3.color = Color(0, 0, 1)
		for t in connected_tourelles:
			unlink_tourelle(t)
			t.destroy_cables_to(self)
		
	$CanvasLayer/Node2D.visible = player.tuto_ordi
	if player.tuto_ordi:
		var pos = get_global_transform_with_canvas().get_origin()
		$CanvasLayer/Node2D.set_position(pos)
		$CanvasLayer/Node2D/Tuto.text = "PRESS '" + get_InputEvent_name(InputMap.get_action_list("Use")) + "' TO CONNECT"

	pass

func dead():
	if dead:
		return
	dead = true
	$bsod.play()

func link_tourelle(t):
	connected_tourelles.push_back(t)

func unlink_tourelle(t):
	var id = connected_tourelles.find(t)
	if id > -1:
		connected_tourelles.remove(id)

func methodeQuiSertARienOrdiMere():
	pass

func get_InputEvent_name(input_array:Array)->String:
	var text:String = ""
	var joypad = Input.get_connected_joypads().size() > 0
	for event in input_array:
		if event is InputEventKey and not joypad:
			text = event.as_text()
		elif event is InputEventJoypadButton and joypad:
			if Input.is_joy_known(event.device):
				text = str(Input.get_joy_button_string(event.button_index))
			else:
				text = "Btn. " + str(event.button_index)
	return text
