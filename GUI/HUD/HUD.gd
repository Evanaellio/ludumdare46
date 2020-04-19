extends CanvasLayer

var arrows: Array

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
			

func _on_Player_update_electronics(nb_electronics):
	$NbElectronics.text = str(nb_electronics)


func _on_Puppeteer_time_to_next_wave(time_to_next_wave, wave_num):
	if time_to_next_wave > 0:
		$NextWave.text = "NEXT WAVE IN " + str(round(time_to_next_wave))
	elif wave_num > 0:
		$NextWave.text = "WAVE " + str(wave_num)

func _on_Puppeteer_enemy_count(current, total):
	$NbEnemies.text = str(current) + "/" + str(total)
