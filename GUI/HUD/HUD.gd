extends CanvasLayer

var arrows: Array

var tuto = true

func _process(_delta):
	var arrowi = 0
	for a in arrows:
		a.visible = false

	var rec: TextureRect = $TextureRect
	var bottomright = rec.get_global_transform_with_canvas().get_origin()

	for i in get_parent().get_children():
		if i.has_method("methodeQuiSertARienDrone"):
			if arrowi >= arrows.size():
				arrows.push_back($Arrow.duplicate())
				add_child(arrows[arrowi])
			var arrow: Node2D = arrows[arrowi]
			arrowi += 1
			
			var drone_pos = i.get_global_transform_with_canvas().get_origin()
			
			var show = drone_pos.x > bottomright.x or drone_pos.y > bottomright.y or drone_pos.x < 0 or drone_pos.y < 0
			
			var vector = bottomright / 2.0 - drone_pos
			
			arrow.visible = show
			arrow.set_position(bottomright / 2.0)
			arrow.look_at(drone_pos)
			arrow.translate(vector.normalized() * -80)

	if Input.is_action_just_pressed("Turret"):
		tuto = false

	$Tuto.visible = tuto
	if tuto:
		var key = get_InputEvent_name(InputMap.get_action_list("Turret"))
		var txt = "PRESS '" + key + "' TO BUILD A TURRET FOR 10 [img=6]res://Prefabs/Electronics/electronics.png[/img]"
		$Tuto.bbcode_text = txt

func _on_Player_update_electronics(nb_electronics):
	$NbElectronics.text = str(nb_electronics)


func _on_Puppeteer_time_to_next_wave(time_to_next_wave, wave_num):
	if time_to_next_wave > 0:
		$NextWave.text = "NEXT WAVE IN " + str(round(time_to_next_wave))
	elif wave_num > 0:
		$NextWave.text = "WAVE " + str(wave_num)

func _on_Puppeteer_enemy_count(current, total):
	$NbEnemies.text = str(current) + "/" + str(total)

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
