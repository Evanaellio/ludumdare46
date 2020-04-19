extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Player_update_electronics(nb_electronics):
	$NbElectronics.text = str(nb_electronics)


func _on_Puppeteer_time_to_next_wave(time_to_next_wave, wave_num):
	if time_to_next_wave > 0:
		$NextWave.text = "NEXT WAVE IN " + str(round(time_to_next_wave))
	elif wave_num > 0:
		$NextWave.text = "WAVE " + str(wave_num)

func _on_Puppeteer_enemy_count(current, total):
	$NbEnemies.text = str(current) + "/" + str(total)
